# NOTE: `docker_space` is the name of the folder containing the repo.

function complete_all {
	_complete_dc()
	{
			local cur prev opts
			COMPREPLY=()
			cur="${COMP_WORDS[COMP_CWORD]}"
			prev="${COMP_WORDS[COMP_CWORD-1]}"
			
			opts=$(find ~/docker_space/ -maxdepth 1 -type d | xargs -I {} basename {})

			if [[ ${prev} == 'dc' ]] || [[ ${prev} == 'dcb' ]]; then
					COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
					return 0
			fi
	}

	complete -F _complete_dc dc
	complete -F _complete_dc dcb
}

# TODO : (dc) Add the completion feature of compose command after the %@

function dc {
	local docker_compose_project=$1
	shift

	local config_file="~/docker_space/${docker_compose_project}/docker-compose.yml"  
	local shared_env_file="~/docker_space/.env"
	local specific_env_file="~/docker_space/${docker_compose_project}/.env"

	docker compose -f ${config_file} --env-file ${shared_env_file} --env-file ${specific_env_file} $@
}

function dcb {
	local docker_compose_project=$1
	local service=$2

	local config_file="~/docker_space/${docker_compose_project}/docker-compose.yml"  
	local shared_env_file="~/docker_space/.env"
	local specific_env_file="~/docker_space/${docker_compose_project}/.env"

	docker compose -f ${config_file} --env-file ${shared_env_file} --env-file ${specific_env_file} exec $2 bash
}
