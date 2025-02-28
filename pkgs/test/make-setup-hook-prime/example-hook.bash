# shellcheck shell=bash

# Add the hooks we want to run to scriptHooks, which are defined as part of testers.testEqualArrayOrMap.
scriptHooks+=(
  copyValuesArrayToActualArray
  addOneToActualArrayMembers
)

copyValuesArrayToActualArray() {
  # NOTE: Concatenation is important here, because we want to be able to detect if the hooks was run twice (resulting
  # actualArray being twice the size of valuesArray).
  nixLog "concatenating valuesArray to actualArray"
  actualArray+=("${valuesArray[@]}")
}

addOneToActualArrayMembers() {
  nixLog "adding one to each member of actualArray"
  local -i i
  for ((i = 0; i < ${#actualArray[@]}; i++)); do
    actualArray[i]=$((actualArray[i] + 1))
  done
}
