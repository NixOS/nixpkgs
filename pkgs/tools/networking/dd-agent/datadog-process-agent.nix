{ lib, datadog-agent }:
datadog-agent.overrideAttrs (attrs: {
  pname = "datadog-process-agent";
  meta =
    attrs.meta
    // {
      description = "Live process collector for the DataDog Agent v7";
      mainProgram = "process-agent";
      maintainers = with lib.maintainers; [ domenkozar ];
    };
  subPackages = [ "cmd/process-agent" ];
  postInstall = null;
})
