set -gx EDITOR nvim
set -gx VISUAL nvim

# this checks if fish is running in interactive shell
if not status is-interactive
    exit 0
end


fish_add_path ~/.local/bin
