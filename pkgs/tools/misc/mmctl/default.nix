{
  mattermost,
}:

mattermost.overrideAttrs (o: {
  pname = "mmctl";
  subPackages = [ "cmd/mmctl" ];

  meta = o.meta // {
    description = "A remote CLI tool for Mattermost";
    mainProgram = "mmctl";
  };
})
