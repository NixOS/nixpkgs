{ mattermost
}:

mattermost.overrideAttrs (o: {
  pname = "mmctl";
  subPackages = [ "cmd/mmctl" ];

  meta = o.meta // {
    description = "Remote CLI tool for Mattermost";
    mainProgram = "mmctl";
  };
})
