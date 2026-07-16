uv-version-pretend-hook() {
  echo "Setting UV_DYNAMIC_VERSIONING_BYPASS to $version"
  export UV_DYNAMIC_VERSIONING_BYPASS=$version
}

if [ -z "${dontBypassUvDynamicVersioning-}" ]; then
  preBuildHooks+=(uv-version-pretend-hook)
fi
