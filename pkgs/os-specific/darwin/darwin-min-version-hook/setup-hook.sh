local role_post
getHostRole

# Compare the requested deployment target to the existing one. The deployment target has to be a version number,
# and this hook tries to do the right thing with deployment targets set outside of it, so it has to parse
# the version numbers for the comparison manually.

local darwinMinVersion=@deploymentTarget@
local darwinMinVersionVar=@darwinMinVersionVariable@${role_post}

local currentDeploymentTargetArr
IFS=. read -a currentDeploymentTargetArr <<< "${!darwinMinVersionVar-0.0.0}"

local darwinMinVersionArr
IFS=. read -a darwinMinVersionArr <<< "$darwinMinVersion"

local currentDeploymentTarget
currentDeploymentTarget=$(printf "%02d%02d%02d" "${currentDeploymentTargetArr[0]-0}" "${currentDeploymentTargetArr[1]-0}" "${currentDeploymentTargetArr[2]-0}")

darwinMinVersion=$(printf "%02d%02d%02d" "${darwinMinVersionArr[0]-0}" "${darwinMinVersionArr[1]-0}" "${darwinMinVersionArr[2]-0}")

if [ "$darwinMinVersion" -gt "$currentDeploymentTarget" ]; then
    export "$darwinMinVersionVar"=@deploymentTarget@
fi

unset -v role_post currentDeploymentTarget currentDeploymentTargetArr darwinMinVersion darwinMinVersionArr darwinMinVersionVar
