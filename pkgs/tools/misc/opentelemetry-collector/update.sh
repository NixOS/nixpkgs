#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix-update common-updater-scripts
set -euf

# Get latest version from releases repo
version=$(curl https://api.github.com/repos/open-telemetry/opentelemetry-collector-releases/releases/latest | jq -r '.name')
version=${version#v}

# Update builder
nix-update opentelemetry-collector-builder --version="${version}"

# Update the otel-collector-releases source
update-source-version opentelemetry-collector-releases.otelcol "${version}" --source-key="releasesSrc"

# Update the individual distributions
for dist in {"",-contrib,-k8s,-otlp}
do
  nix-update "opentelemetry-collector-releases.otelcol${dist}" --version skip
done
