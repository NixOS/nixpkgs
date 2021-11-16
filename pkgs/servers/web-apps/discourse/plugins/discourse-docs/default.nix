{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-docs";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-docs";
    rev = "72cdd8d415ae3f797c0d5e2c857370714a42c54a";
    sha256 = "07hvw8lpg8873vhwh8rrbml3s5hq606b7sw93r2xv38gxfhmx5lq";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-docs";
    maintainers = with maintainers; [ dpausp ];
    license = licenses.mit;
    description = "Find and filter knowledge base topics";
  };
}
