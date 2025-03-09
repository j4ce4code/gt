# gt

`gt` (GoTo) is a lightweight shell function that allows you to quickly change directories based on key-to-path mappings defined in a configuration file. With a simple command, you can jump to frequently used directories, making navigation faster and more efficient.

## Features

- **Quick Navigation:** Jump to a directory using a simple key.
- **Configurable:** Mappings are stored in a dedicated file (`~/.gt_locations`).
- **Help Functionality:** Run `gt --help` to list all available mappings.
- **Error Handling:** Displays helpful messages if a key isn’t found or if the configuration file is missing.

## Installation

1. **Download the Function**

   Save the `gt` function to a file (for example, `gt.sh`).

2. **Source the Function in Your Shell**

   - **Bash:** Add the following line to your `~/.bashrc`:
     ```bash
     source /path/to/gt.sh
     ```
   - **Zsh:** Add the following line to your `~/.zshrc`:
     ```bash
     source /path/to/gt.sh
     ```

3. **Apply Changes**

   Restart your terminal or source your configuration file manually:
   ```bash
   source ~/.bashrc
   # or
   source ~/.zshrc

## Configuration

`gt` uses a configuration file located at ~/.gt_locations to store your directory mappings. Each line in this file should follow the format:

```bash
key: /absolute/path/to/directory
```
   - Lines starting with # are treated as comments.
   - Blank lines are ignored.

Example `~/.gt_locations` file:
```bash
# My directory mappings
work: /home/username/projects/work
docs: /home/username/Documents
```

## Usage
Changing Directories
To navigate to a mapped directory, simply run:
```bash
gt <key>
```
For example, if you have the mapping work: /home/username/projects/work, type:
```bash
gt work
```
The function will change your current directory to `/home/username/projects/work`.

## Display Mappings
To view all available mappings, run:
```bash
gt --help
```
