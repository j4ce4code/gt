gt() {
  local locations_file="${HOME}/.gt_locations"

  # Support adding new mappings
  if [ "$1" = "add" ]; then
    shift 1 # Remove "add" from the parameters

    local override=0
    # Check if the last argument is "-o" for override
    if [ "$#" -ge 1 ] && [ "${!#}" = "-o" ]; then
      override=1
      # Remove the override flag from the parameters
      set -- "${@:1:$(($# - 1))}"
    fi

    if [ "$#" -eq 0 ]; then
      echo "Usage: gt add <key> [<path>] [-o]"
      return 1
    fi

    local key="$1"
    local path
    if [ "$#" -ge 2 ]; then
      path="$2"
    else
      path="$PWD"
    fi

    # Ensure the locations file exists, or create it.
    if [ ! -f "$locations_file" ]; then
      touch "$locations_file" || {
        echo "Error: Unable to create $locations_file"
        return 1
      }
    fi

    # Check for existing key collision
    if grep -q -E "^[[:space:]]*${key}[[:space:]]*:" "$locations_file"; then
      if [ "$override" -eq 0 ]; then
        echo "Error: Key '$key' already exists. Use -o to override."
        return 1
      else
        # Remove the existing mapping for this key (backup the file first)
        sed -i.bak "/^[[:space:]]*${key}[[:space:]]*:/d" "$locations_file" || {
          echo "Error: Unable to remove existing key '$key'."
          return 1
        }
      fi
    fi

    # Append the new mapping to the locations file.
    echo "${key}: ${path}" >>"$locations_file"
    echo "Mapping added: ${key} -> ${path}"
    return 0
  fi

  # Display help and list all mappings if --help is passed.
  if [ "$1" = "--help" ]; then
    if [ -f "$locations_file" ]; then
      echo "Available mappings from $locations_file:"
      # Ignore comments (lines starting with #) and blank lines.
      grep -Ev '^[[:space:]]*#|^[[:space:]]*$' "$locations_file" | while IFS=':' read -r key path; do
        # Trim whitespace from key and path
        key=$(echo "$key" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        path=$(echo "$path" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        echo "  $key -> $path"
      done
    else
      echo "Locations file not found: $locations_file"
    fi
    return 0
  fi

  # Check that a key is provided.
  if [ $# -eq 0 ]; then
    echo "Usage: gt <key>"
    echo "       gt add <key> [<path>] [-o]  # Add a new mapping"
    echo "Run 'gt --help' to see available mappings."
    return 1
  fi

  local key="$1"

  if [ ! -f "$locations_file" ]; then
    echo "Locations file not found: $locations_file"
    return 1
  fi

  # Find the line that matches the key.
  local line
  line=$(grep -E "^[[:space:]]*${key}[[:space:]]*:" "$locations_file")
  if [ -z "$line" ]; then
    echo "Key not found: $key"
    return 1
  fi

  # Extract the path by removing everything before the colon and trimming spaces.
  local path
  path=$(echo "$line" | cut -d ':' -f2- | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  if [ -z "$path" ]; then
    echo "No path specified for key: $key"
    return 1
  fi

  cd "$path" || {
    echo "Failed to change directory to: $path"
    return 1
  }
}
