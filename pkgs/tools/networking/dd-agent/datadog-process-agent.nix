{ lib, datadog-agent }:
datadog-agent.overrideAttrs (attrs: {
  pname = "datadog-process-agent";
  meta =
    with lib;
    attrs.meta
    // {
      description = "Live process collector for the DataDog Agent v7";
      mainProgram = "process-agent";
      maintainers = with maintainers; [ domenkozar ];
    };
  subPackages = [ "cmd/process-agent" ];
  postInstall = null;
})
