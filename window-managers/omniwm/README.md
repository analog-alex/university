# OmniWM Keybindings

Quick reference for my current OmniWM setup. These bindings are read from
`~/.config/omniwm/settings.toml`; they are customized and may differ from
OmniWM defaults.

## Workspaces

`Option` switches to a workspace; adding `Shift` moves the focused window there.

| Workspace | Layout | Switch to workspace | Move focused window there |
| --- | --- | --- | --- |
| 1 | Dwindle | `Option+A` | `Option+Shift+A` |
| 2 | Niri | `Option+S` | `Option+Shift+S` |
| 3 | Dwindle | `Option+D` | `Option+Shift+D` |
| 4 | Dwindle | `Option+F` | `Option+Shift+F` |
| 5 | Niri | `Option+G` | `Option+Shift+G` |
| 6 | Niri | `Option+Z` | `Option+Shift+Z` |
| 7 | Niri | `Option+X` | `Option+Shift+X` |
| 8 | Niri | `Option+C` | `Option+Shift+C` |
| 9 | Niri | `Option+V` | `Option+Shift+V` |

`Control+Option+Tab` switches back to the previous workspace.

## Shared navigation and window movement

| Action | Shortcut |
| --- | --- |
| Focus left / down / up / right | `Option+J` / `Option+K` / `Option+I` / `Option+L` |
| Move focused window left / down / up / right | `Option+Shift+J` / `Option+Shift+K` / `Option+Shift+I` / `Option+Shift+L` |
| Focus previous window | `Option+Tab` |

## Dwindle workspaces

| Action | Shortcut |
| --- | --- |
| Move focused window to the root split | `Option+H` |
| Toggle the active split orientation | `Option+U` |
| Swap the active split | `Option+Y` |
| Grow / shrink the focused window | `Option+N` / `Option+M` |

## Niri workspaces

| Action | Shortcut |
| --- | --- |
| Focus first / last column | `Option+Shift+7` (`&` on a US keyboard) / `Option+Shift+3` (`#` on a US keyboard) |
| Focus column 1–9 by position | `Control+Option+1`–`9` |
| Toggle tabbed windows in a column | `Option+T` |
| Move focused window to workspace above / below | `Control+Option+Shift+I` / `Control+Option+Shift+K` |
| Move column to workspace above / below | `Control+Option+Shift+Page Up` / `Control+Option+Shift+Page Down` |
| Toggle full primary span | `Option+Shift+W` |
| Expand container to available primary span | `Control+Option+F` |
| Reset window secondary span | `Control+Option+R` |
| Shrink / grow container primary span | `Option+-` / `Option+=` |
| Shrink / grow window secondary span | `Option+Shift+-` / `Option+Shift+=` |

## Shared layout controls

| Action | Shortcut |
| --- | --- |
| Toggle OmniWM fullscreen | `Option+Return` |
| Toggle focused window floating / tiled | `Option+R` |
| Cycle size backward / forward | `Option+,` / `Option+.` |
| Balance layout sizes | `Option+Shift+B` |
| Toggle workspace layout (Niri / Dwindle) | `Option+P` |

## Updating the bindings

Edit the matching entries in `~/.config/omniwm/settings.toml` under `[[hotkeys]]`.
OmniWM watches this file and reloads it when saved. The first/last Niri column
bindings are stored as `Option+Shift+7` and `Option+Shift+3`; on a US keyboard,
these produce the `&` and `#` symbols respectively.
