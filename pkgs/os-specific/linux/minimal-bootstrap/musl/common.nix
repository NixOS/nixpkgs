{ lib }:

{
  pname = "musl";

  meta = {
    description = "Efficient, small, quality libc implementation";
    homepage = "https://musl.libc.org";
    license = lib.licenses.mit;
    maintainers = lib.teams.minimal-bootstrap.members;
    platforms = lib.platforms.unix;
  };
}
