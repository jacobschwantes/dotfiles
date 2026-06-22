# dotfiles shell aliases — dot-sourced from the PowerShell $PROFILE by install.ps1
# Windows PowerShell / PowerShell 7+

# cc: launch Claude Code skipping permission prompts.
# (A function, not Set-Alias, so arguments pass through.)
function cc { claude --dangerously-skip-permissions @args }

# dn: open today's Obsidian daily note (created from the template if missing)
# and focus it. Uses the vault *name*, so it's portable across machines.
function dn { Start-Process "obsidian://daily?vault=Obsidian%20Vault" }
