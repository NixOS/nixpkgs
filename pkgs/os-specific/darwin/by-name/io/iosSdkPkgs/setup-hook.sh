# Export SDKROOT / DEVELOPER_DIR for tools that probe `xcrun
# --show-sdk-path` — xcrun isn't on PATH in the sandbox.
local role_post
getHostRole

local developerDirVar=DEVELOPER_DIR${role_post}
local sdkRootVar=SDKROOT${role_post}

if [ -z "${!sdkRootVar-}" ]; then
    export "$developerDirVar"='@developerDir@'
    export "$sdkRootVar"='@sdk@'
fi

unset -v role_post developerDirVar sdkRootVar
