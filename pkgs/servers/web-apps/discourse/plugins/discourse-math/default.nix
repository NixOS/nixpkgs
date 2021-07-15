{ mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-math";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-math";
    rev = "143ddea4558ea9a1b3fd71635bc11e055763c8e7";
    sha256 = "18pq5ybl3g34i39cpixc3nszvq8gx5yji58zlbbl6428mm011cbx";
  };
}
