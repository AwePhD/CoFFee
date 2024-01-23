conda config --set changeps1 False

function conda_ps1() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        # Conda environment is activated, change color to pink
        # Assuming 'pink' color is available, adjust as needed
        local pink=$(tput setaf 5)
        local reset=$(tput sgr0)
        echo -n "${pink}\$ ${reset}"
    else
        # No Conda environment, use default color
        echo -n "\$ "
    fi
}

__project="mmdet"
__color_host="\[$(tput setaf 11)\]"
__color_dir="\[$(tput setaf 82)\]"
__color_none="\[$(tput sgr0)\]"

__host="${__color_host}$__project"
__prompt_tail="${__color_dir}\W$__color_none"
__end_char="$(conda_ps1)"

export PS1="[${__host} $__prompt_tail]$__end_char"
export PATH="$PATH:${HOME}/.local/bin"
set -o vi
