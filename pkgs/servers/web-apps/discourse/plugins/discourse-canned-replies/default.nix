{ lib, mkDiscoursePlugin, fetchFromGitHub }:

mkDiscoursePlugin {
  name = "discourse-canned-replies";
  src = fetchFromGitHub {
    owner = "discourse";
    repo = "discourse-canned-replies";
    rev = "fe92bc1324fe0d2519f0e33b3fd89a4bed21b2e9";
    sha256 = "sha256-m+DDS93XJAN9RqX8pXeA78gY+p+7A2ey1oblGpcB4L0=";
  };
  meta = with lib; {
    homepage = "https://github.com/discourse/discourse-canned-replies";
    maintainers = with maintainers; [ talyz ];
    license = licenses.gpl2Only;
    description = "Adds support for inserting a canned reply into the composer window via a UI";
  };
}
