#!/bin/bash

# Script to create the directory structure and files for the knowledge-transfer-cli Go project.

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the project root directory name
PROJECT_DIR="knowledge-transfer-cli"

# --- Create Project Directory ---
echo "Creating project directory: $PROJECT_DIR"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"
echo "Changed directory to $(pwd)"

# --- Create Subdirectories ---
echo "Creating subdirectory: cmd"
mkdir -p "cmd"

echo "Creating subdirectory: internal/visualization"
mkdir -p "internal/visualization"

# --- Create main.go ---
echo "Creating file: main.go"
cat <<EOF >main.go
// main.go
package main

import (
	"knowledge-transfer-cli/cmd"
	"os"
)

// main is the entry point of the application.
func main() {
	// Execute the root command. If it fails, os.Exit(1) is called by cobra.
	if err := cmd.Execute(); err != nil {
		// Cobra's Execute() already prints the error to stderr.
		// We exit with 1 to indicate an error to the shell.
		os.Exit(1)
	}
}
EOF

# --- Create go.mod ---
echo "Creating file: go.mod"
cat <<EOF >go.mod
module knowledge-transfer-cli

go 1.22.0

require github.com/spf13/cobra v1.8.0

require (
	github.com/inconshreveable/mousetrap v1.1.0 // indirect
	github.com/spf13/pflag v1.0.5 // indirect
)
EOF

# --- Create cmd/root.go ---
echo "Creating file: cmd/root.go"
cat <<EOF >cmd/root.go
package cmd

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "kt-cli",
	Short: "A CLI tool for knowledge transfer visualization prompts.",
	Long: \`kt-cli is a command-line application designed to help you understand
and structure information for knowledge transfer, even without visual tools.

It provides descriptions of various visualization techniques and textual
templates to guide your thinking. This tool aims to offer educative value
by focusing on the principles behind effective knowledge sharing.\`,
	// Uncomment the following line if your bare application
	// has an action associated with it:
	// Run: func(cmd *cobra.Command, args []string) { },
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() error {
	return rootCmd.Execute()
}

func init() {
	// Here you will define your flags and configuration settings.
	// Cobra supports persistent flags, which, if defined here,
	// will be global for your application.
	// rootCmd.PersistentFlags().StringVar(&cfgFile, "config", "", "config file (default is \$HOME/.knowledge-transfer-cli.yaml)")

	// Cobra also supports local flags, which will only run
	// when this action is called directly.
	// rootCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

// Helper function to print errors and exit
func er(msg interface{}) {
	fmt.Fprintln(os.Stderr, "Error:", msg)
	os.Exit(1)
}
EOF

# --- Create internal/visualization/types.go ---
echo "Creating file: internal/visualization/types.go"
cat <<EOF >internal/visualization/types.go
package visualization

// VisualizationType represents a type of knowledge transfer visualization.
type VisualizationType struct {
	Name             string
	Description      string
	UseCases         []string
	TextualGuideline string // A template or guide on how to represent it textually
}

// Repository defines the interface for accessing visualization types.
type Repository interface {
	GetTypes() ([]VisualizationType, error)
	GetTypeByName(name string) (VisualizationType, error)
}
EOF

# --- Create internal/visualization/repository_mem.go ---
echo "Creating file: internal/visualization/repository_mem.go"
cat <<EOF >internal/visualization/repository_mem.go
package visualization

import (
	"fmt"
	"strings"
)

// InMemoryRepository is an in-memory implementation of the Repository interface.
type InMemoryRepository struct {
	types map[string]VisualizationType
}

// NewInMemoryRepository creates a new instance of InMemoryRepository
// and populates it with predefined visualization types.
func NewInMemoryRepository() *InMemoryRepository {
	repo := &InMemoryRepository{
		types: make(map[string]VisualizationType),
	}
	repo.loadPredefinedTypes()
	return repo
}

func (r *InMemoryRepository) loadPredefinedTypes() {
	r.types["mindmap"] = VisualizationType{
		Name:        "Mind Map",
		Description: "A hierarchical diagram used to visually organize information around a central concept. It branches out into related ideas and sub-topics.",
		UseCases: []string{
			"Brainstorming new ideas.",
			"Summarizing complex information.",
			"Note-taking during lectures or meetings.",
			"Planning projects or essays.",
			"Problem-solving by exploring different facets of an issue.",
		},
		TextualGuideline: \`
Textual Mind Map Guideline:

Central Topic: [Clearly state the main subject or problem]
    └── Main Branch 1: [Key theme or primary idea related to the central topic]
        ├── Sub-Branch 1.1: [Supporting detail, sub-idea, or example]
        │   └── Sub-Sub-Branch 1.1.1: [Further elaboration or specific point]
        └── Sub-Branch 1.2: [Another supporting detail or sub-idea]
    └── Main Branch 2: [Another key theme or primary idea]
        ├── Sub-Branch 2.1: [Supporting detail]
        └── Sub-Branch 2.2: [Supporting detail]
            ├── Sub-Sub-Branch 2.2.1: [Elaboration]
    └── Main Branch 3: [Yet another key theme]
        └── Sub-Branch 3.1: [Detail]

Tips for textual mind mapping:
- Use indentation to represent hierarchy.
- Start with the most general concepts and become more specific.
- Use keywords and short phrases.
- Clearly label each branch and sub-branch.
		\`,
	}

	r.types["flowchart"] = VisualizationType{
		Name:        "Flowchart",
		Description: "A diagram that represents a workflow, process, or algorithm using standardized symbols connected by arrows to show sequence and decision points.",
		UseCases: []string{
			"Documenting existing processes for clarity and training.",
			"Designing new workflows or systems.",
			"Troubleshooting problems by mapping out steps.",
			"Explaining decision-making paths.",
			"Software algorithm design and representation.",
		},
		TextualGuideline: \`
Textual Flowchart Guideline:

Process Name: [Name of the process being mapped]

1.  Start: [Describe the trigger or initial state of the process]
    Symbol: (Oval - Terminator)

2.  Step/Action: [Describe the first action or operation]
    Symbol: (Rectangle - Process)
    Details: [Any necessary elaboration for this step]

3.  Decision: [Pose a question that has a clear Yes/No or True/False answer]
    Symbol: (Diamond - Decision)
    ├── If YES:
    │   └── Step/Action: [Describe the action taken if the answer is YES]
    │       Symbol: (Rectangle - Process)
    │       Next: [Indicate the next step number or 'End']
    └── If NO:
        └── Step/Action: [Describe the action taken if the answer is NO]
            Symbol: (Rectangle - Process)
            Next: [Indicate the next step number or 'End']

4.  Step/Action: [Describe another action or operation in the main flow]
    Symbol: (Rectangle - Process)
    Leads to: [Step number] or [Another Decision]

... (Continue numbering steps, decisions, and actions)

N.  End: [Describe the final outcome or termination point of the process]
    Symbol: (Oval - Terminator)

Connectors:
- Use "Leads to: [Step X]" or "Next: [Step Y]" to indicate flow.
- For loops, you might say "Return to: Step Z".

Tips for textual flowcharts:
- Be sequential and logical.
- Clearly state conditions for decisions.
- Ensure all paths lead to an end point or loop back appropriately.
		\`,
	}

	r.types["conceptmap"] = VisualizationType{
		Name:        "Concept Map",
		Description: "A graphical tool that depicts relationships between concepts. Concepts are typically represented as nodes (boxes or circles), and relationships are shown by linking lines with connecting phrases.",
		UseCases: []string{
			"Organizing and representing complex knowledge structures.",
			"Facilitating meaningful learning by linking new and existing knowledge.",
			"Assessing understanding of a topic.",
			"Planning writing or research by outlining conceptual relationships.",
			"Communicating complex ideas and their interconnections.",
		},
		TextualGuideline: \`
Textual Concept Map Guideline:

Focus Question (Optional but Recommended): [What question does this concept map aim to answer?]

Key Concepts & Definitions:
- Concept A: [Brief definition or description of Concept A]
- Concept B: [Brief definition or description of Concept B]
- Concept C: [Brief definition or description of Concept C]
... and so on for all major concepts.

Relationships (Propositions):
Format: [Concept 1] --(Linking Phrase)--> [Concept 2]

Examples:
- [Water] --(can be in state of)--> [Ice]
- [Learning] --(is facilitated by)--> [Active Engagement]
- [Photosynthesis] --(requires)--> [Sunlight]
- [Photosynthesis] --(produces)--> [Oxygen]
- [Climate Change] --(is influenced by)--> [Greenhouse Gases]
- [Greenhouse Gases] --(include)--> [Carbon Dioxide]

Hierarchy/Structure (if applicable):
- Main Concept: [Overall theme or most inclusive concept]
    - Related Concept 1: [A major concept linked to the main one]
        - Sub-Concept 1.1 --(linking phrase)--> Related Concept 1
    - Related Concept 2: [Another major concept]
        - [Related Concept 2] --(linking phrase)--> [Sub-Concept 2.1]

Cross-links (Relationships between concepts in different parts of the map):
- [Concept X from one branch] --(Linking Phrase)--> [Concept Y from another branch]

Tips for textual concept mapping:
- Start with a focus question or main topic.
- Identify key concepts (nouns or noun phrases).
- Use clear and concise linking phrases (verbs or short phrases) to show relationships.
- Arrange concepts hierarchically if appropriate, from general to specific.
- Look for cross-links that connect different areas of the map.
		\`,
	}
	// Add more visualization types here
}

// GetTypes returns all available visualization types.
func (r *InMemoryRepository) GetTypes() ([]VisualizationType, error) {
	if len(r.types) == 0 {
		return nil, fmt.Errorf("no visualization types loaded")
	}
	var typesList []VisualizationType
	for _, v := range r.types {
		typesList = append(typesList, v)
	}
	return typesList, nil
}

// GetTypeByName returns a specific visualization type by its name (case-insensitive).
func (r *InMemoryRepository) GetTypeByName(name string) (VisualizationType, error) {
	lowerName := strings.ToLower(name)
	vType, ok := r.types[lowerName]
	if !ok {
		// Try to find a partial match for convenience
		for k, val := range r.types {
			if strings.Contains(k, lowerName) {
				return val, nil
			}
		}
		return VisualizationType{}, fmt.Errorf("visualization type '%s' not found", name)
	}
	return vType, nil
}
EOF

# --- Create cmd/list.go ---
echo "Creating file: cmd/list.go"
cat <<EOF >cmd/list.go
package cmd

import (
	"fmt"
	"knowledge-transfer-cli/internal/visualization"
	"os"

	"github.com/spf13/cobra"
)

var listCmd = &cobra.Command{
	Use:   "list-types",
	Short: "Lists all available knowledge transfer visualization types",
	Long: \`Prints a list of all knowledge transfer visualization types
that this CLI tool can provide information about.\`,
	Run: func(cmd *cobra.Command, args []string) {
		repo := visualization.NewInMemoryRepository()
		types, err := repo.GetTypes()
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error getting visualization types: %v\n", err)
			os.Exit(1)
		}

		if len(types) == 0 {
			fmt.Println("No visualization types available.")
			return
		}

		fmt.Println("Available Knowledge Transfer Visualization Types:")
		for _, t := range types {
			fmt.Printf("- %s\n", t.Name)
		}
		fmt.Println("\nUse 'kt-cli describe <type_name>' to get more details about a specific type.")
		fmt.Println("For example: 'kt-cli describe mindmap'")
	},
}

func init() {
	rootCmd.AddCommand(listCmd)
}
EOF

# --- Create cmd/describe.go ---
echo "Creating file: cmd/describe.go"
cat <<EOF >cmd/describe.go
package cmd

import (
	"fmt"
	"knowledge-transfer-cli/internal/visualization"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

var describeCmd = &cobra.Command{
	Use:   "describe [type_name]",
	Short: "Describes a specific knowledge transfer visualization type",
	Long: \`Provides a detailed description, use cases, and a textual guideline
for a specified knowledge transfer visualization type.
The type_name can be one of the types listed by 'kt-cli list-types'.
Matching is case-insensitive and supports partial names (e.g., "flow" for "Flowchart").\`,
	Args: cobra.ExactArgs(1), // Requires exactly one argument: the type_name
	Run: func(cmd *cobra.Command, args []string) {
		typeName := args[0]
		repo := visualization.NewInMemoryRepository()

		vizType, err := repo.GetTypeByName(typeName)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error: %v\n", err)
			fmt.Println("\nRun 'kt-cli list-types' to see available types.")
			os.Exit(1)
		}

		fmt.Printf("--- %s ---\n\n", vizType.Name)
		fmt.Printf("Description:\n%s\n\n", vizType.Description)

		fmt.Println("Common Use Cases:")
		for _, uc := range vizType.UseCases {
			fmt.Printf("- %s\n", uc)
		}

		fmt.Printf("\nTextual Guideline / Template:\n%s\n", strings.TrimSpace(vizType.TextualGuideline))
	},
}

func init() {
	rootCmd.AddCommand(describeCmd)
}
EOF

# --- Final Instructions ---
echo ""
echo "---------------------------------------------------------------------"
echo "Project structure and files created successfully in '$PROJECT_DIR'."
echo "---------------------------------------------------------------------"
echo ""
echo "Next steps:"
echo "1. Navigate to the project directory: cd $PROJECT_DIR"
echo "2. Initialize Go modules (if not already done by your Go environment or if go.mod was changed): go mod tidy"
echo "3. Build the application: go build ."
echo "4. Run the application:"
echo "   ./$PROJECT_DIR list-types"
echo "   ./$PROJECT_DIR describe mindmap"
echo "   (On Windows, use: .\\${PROJECT_DIR}.exe list-types)"
echo ""
echo "Note: Ensure you have Go installed and configured in your PATH."
echo "If you encounter any issues with line endings on Windows, you might need to convert them (e.g., using dos2unix or a text editor)."
echo "---------------------------------------------------------------------"

# Return to the original directory
cd ..
