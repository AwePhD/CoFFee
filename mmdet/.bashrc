conda config --set changeps1 False

update_ps1() {
		# Color of $ accordingly to the activation of conda's env
		local __end_char
    if [[ -n "$CONDA_PREFIX" ]]; then
        local pink="\[$(tput setaf 5)\]"
        local reset="\[$(tput sgr0)\]"
        __end_char="${pink}\$ ${reset}"
    else
        __end_char="\$ "
    fi
		local __project="mmdet"
		local __color_host="\[$(tput setaf 11)\]"
		local __color_dir="\[$(tput setaf 82)\]"
		local __color_none="\[$(tput sgr0)\]"

		local __host="${__color_host}$__project"
		local __prompt_tail="${__color_dir}\W$__color_none"

		PS1="[${__host} $__prompt_tail]$__end_char"
}

PROMPT_COMMAND=update_ps1

export PATH="$PATH:${HOME}/.local/bin"
set -o vi
