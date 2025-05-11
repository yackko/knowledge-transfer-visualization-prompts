# Go Knowledge Transfer CLI Project Setup Script (`create_kt_cli_project.sh`)

This shell script automates the creation of the directory structure and initial files for the "Knowledge Transfer CLI" (kt-cli) Go project. The kt-cli application is designed to help users understand and structure information for knowledge transfer using textual representations of visualization techniques.

## Purpose

The primary purpose of this script is to save time and ensure consistency when setting up the project environment. It creates:
- The main project directory (`knowledge-transfer-cli`).
- Subdirectories for commands (`cmd`) and internal logic (`internal/visualization`).
- All necessary Go source files (`main.go`, `cmd/root.go`, `cmd/list.go`, `cmd/describe.go`, `internal/visualization/types.go`, `internal/visualization/repository_mem.go`) with their initial content.
- A `go.mod` file with the required module path and dependencies.

## Prerequisites

Before running this script, ensure you have the following installed on your system:
- **Bash:** The script is a Bash shell script and needs a Bash-compatible environment to run (common on Linux and macOS; available on Windows via WSL or Git Bash).
- **Go:** The Go programming language (version 1.22 or later, as specified in the `go.mod` file) is required to build and run the generated project. Make sure Go is correctly installed and its `bin` directory is in your system's PATH.

## How to Use

1.  **Save the Script:**
    Save the content of the script provided in the document with the ID `golang_kt_cli_setup_script` to a file named `create_kt_cli_project.sh` on your local machine.

2.  **Make it Executable:**
    Open your terminal or command prompt, navigate to the directory where you saved the script, and make it executable:
    ```bash
    chmod +x create_kt_cli_project.sh
    ```

3.  **Run the Script:**
    Execute the script from the same directory:
    ```bash
    ./create_kt_cli_project.sh
    ```
    The script will print messages indicating the directories and files it's creating.

## What Happens Next?

After the script successfully completes, it will create a new directory named `knowledge-transfer-cli` in the current location. Inside this directory, you'll find the complete project structure.

The script will also print the following "Next steps":

1.  **Navigate to the project directory:**
    ```bash
    cd knowledge-transfer-cli
    ```

2.  **Initialize/Tidy Go modules:**
    This step ensures all dependencies are correctly downloaded and the `go.sum` file is created or updated.
    ```bash
    go mod tidy
    ```

3.  **Build the application:**
    This command compiles the Go source code and creates an executable file (e.g., `knowledge-transfer-cli` on Linux/macOS, `knowledge-transfer-cli.exe` on Windows).
    ```bash
    go build .
    ```

4.  **Run the application:**
    You can now run the compiled CLI tool:
    ```bash
    ./knowledge-transfer-cli list-types
    ./knowledge-transfer-cli describe mindmap
    ```
    On Windows, you would typically run:
    ```bash
    .\knowledge-transfer-cli.exe list-types
    .\knowledge-transfer-cli.exe describe mindmap
    ```

## Script Contents Overview

The script performs the following actions:
- Sets `set -e` to exit immediately if any command fails.
- Defines the project directory name (`PROJECT_DIR`).
- Creates the main project directory and changes into it.
- Creates subdirectories `cmd` and `internal/visualization`.
- Uses `cat <<EOF > filename` (Here Documents) to write the content of each Go file and the `go.mod` file.
- Prints final instructions and guidance to the user.
- Changes back to the original directory from which the script was run.

## Troubleshooting

-   **Permissions Denied:** If you get a "Permission denied" error when trying to run the script, ensure you've made it executable using `chmod +x create_kt_cli_project.sh`.
-   **Command Not Found (go):** If `go mod tidy` or `go build .` fails with "command not found," ensure Go is installed correctly and its `bin` directory is in your system's PATH.
-   **Line Endings (Windows):** If you are on Windows and copied the script content from a source that uses Unix-style line endings (LF), you might encounter issues if your shell environment expects Windows-style line endings (CRLF). Using Git Bash or WSL usually handles this well. If direct execution in CMD or PowerShell fails, consider using `dos2unix` or a text editor (like Notepad++) to convert line endings if necessary, though this is less common for scripts executed via Bash emulators.

This README should help anyone understand and use the setup script effectively.


