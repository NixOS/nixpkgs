builtins.toFile "get-env.sh" ''

  set -e
  if [ -e .attrs.sh ]; then source .attrs.sh; fi

  export IN_NIX_SHELL=impure
  export dontAddDisableDepTrack=1

  if [[ -n $stdenv ]]; then
      source $stdenv/setup
  fi

  # Better to use compgen, but stdenv bash doesn't have it.
  __vars="$(declare -p)"
  __functions="$(declare -F)"

  __dumpEnv() {
      printf '{\n'

      printf '  "bashFunctions": {\n'
      local __first=1
      while read __line; do
          if ! [[ $__line =~ ^declare\ -f\ (.*) ]]; then continue; fi
          __fun_name="''${BASH_REMATCH[1]}"
          __fun_body="$(type $__fun_name)"
          if [[ $__fun_body =~ \{(.*)\} ]]; then
              if [[ -z $__first ]]; then printf ',\n'; else __first=; fi
              __fun_body="''${BASH_REMATCH[1]}"
              printf "    "
              __escapeString "$__fun_name"
              printf ':'
              __escapeString "$__fun_body"
          else
              printf "Cannot parse definition of function '%s'.\n" "$__fun_name" >&2
              return 1
          fi
      done < <(printf "%s\n" "$__functions")
      printf '\n  },\n'

      printf '  "variables": {\n'
      local __first=1
      while read __line; do
          if ! [[ $__line =~ ^declare\ (-[^ ])\ ([^=]*) ]]; then continue; fi
          local type="''${BASH_REMATCH[1]}"
          local __var_name="''${BASH_REMATCH[2]}"

          if [[ $__var_name =~ ^BASH_ || \
                $__var_name =~ ^COMP_ || \
                $__var_name = _ || \
                $__var_name = DIRSTACK || \
                $__var_name = EUID || \
                $__var_name = FUNCNAME || \
                $__var_name = HISTCMD || \
                $__var_name = HOSTNAME || \
                $__var_name = GROUPS || \
                $__var_name = PIPESTATUS || \
                $__var_name = PWD || \
                $__var_name = RANDOM || \
                $__var_name = SHLVL || \
                $__var_name = SECONDS || \
                $__var_name = EPOCHREALTIME || \
                $__var_name = EPOCHSECONDS \
              ]]; then continue; fi

          if [[ -z $__first ]]; then printf ',\n'; else __first=; fi

          printf "    "
          __escapeString "$__var_name"
          printf ': {'

          # FIXME: handle -i, -r, -n.
          if [[ $type == -x ]]; then
              printf '"type": "exported", "value": '
              __escapeString "''${!__var_name}"
          elif [[ $type == -- ]]; then
              printf '"type": "var", "value": '
              __escapeString "''${!__var_name}"
          elif [[ $type == -a ]]; then
              printf '"type": "array", "value": ['
              local __first2=1
              __var_name="$__var_name[@]"
              for __i in "''${!__var_name}"; do
                  if [[ -z $__first2 ]]; then printf ', '; else __first2=; fi
                  __escapeString "$__i"
                  printf ' '
              done
              printf ']'
          elif [[ $type == -A ]]; then
              printf '"type": "associative", "value": {\n'
              local __first2=1
              declare -n __var_name2="$__var_name"
              for __i in "''${!__var_name2[@]}"; do
                  if [[ -z $__first2 ]]; then printf ',\n'; else __first2=; fi
                  printf "      "
                  __escapeString "$__i"
                  printf ": "
                  __escapeString "''${__var_name2[$__i]}"
              done
              printf '\n    }'
          else
              printf '"type": "unknown"'
          fi

          printf "}"
      done < <(printf "%s\n" "$__vars")
      printf '\n  }\n}'
  }

  __escapeString() {
      local __s="$1"
      __s="''${__s//\\/\\\\}"
      __s="''${__s//\"/\\\"}"
      __s="''${__s//$'\n'/\\n}"
      __s="''${__s//$'\r'/\\r}"
      __s="''${__s//$'\t'/\\t}"
      printf '"%s"' "$__s"
  }

  # In case of `__structuredAttrs = true;` the list of outputs is an associative
  # array with a format like `outname => /nix/store/hash-drvname-outname`, so `__olist`
  # must contain the array's keys (hence `''${!...[@]}`) in this case.
  if [ -e .attrs.sh ]; then
      __olist="''${!outputs[@]}"
  else
      __olist=$outputs
  fi

  for __output in $__olist; do
      if [[ -z $__done ]]; then
          __dumpEnv > ''${!__output}
          __done=1
      else
          echo -n >> "''${!__output}"
      fi
  done
''
