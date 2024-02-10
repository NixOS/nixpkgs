{ lib
, buildPythonPackage
, pythonOlder
, aiobotocore
, botocore
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.8.0" "sha256-7TmekyZVc2l2er1TIJURP7Qy0n7xRYnXt44FJr5XBWA=";

  types-aiobotocore-account = buildTypesAiobotocorePackage "account" "2.8.0" "sha256-rVwj3gN9+U5m6xXwytQpE8mSVPTlezzeNIwNH2vgR4Y=";

  types-aiobotocore-acm = buildTypesAiobotocorePackage "acm" "2.8.0" "sha256-VzV8viXJpHfI1aD1UtCX+GSSZKhRSTzMX5dnkGhm+9Y=";

  types-aiobotocore-acm-pca = buildTypesAiobotocorePackage "acm-pca" "2.8.0" "sha256-ib044RjF+1projrSoyiMdj9LkbT1BJrfObxs1ukSNHo=";

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.11.0" "sha256-FF1VOkekfT4cSx2y61smPVMTD5k3FBIsnslOTnxy+5o=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.11.0" "sha256-PzA8ooo026gvNYL+xgjJ1EJomCC+lq1QDbY54k067BM=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.11.0" "sha256-RCC+fkQJMKYrv0TdAUGOXLyufeCJyV9luXKOXvjXc+s=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.11.0" "sha256-U5BemtvxVynvFaQ9gxiI3kFB5+HJjpFTZkXMLFaMeRE=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.11.0" "sha256-4oQMgEJD6RT8ukcdoDF7dWAnNj51gBWOYITKjzLGTBo=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.11.0" "sha256-YGOdBuM5250bIoM2rJeJv51zF6kB1zvGYksmr56SW8g=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.11.0" "sha256-LFI4IJyDQnPYKq0WHk9y56LjdtW6nHHUN2GLGk+ZdLs=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.11.0" "sha256-3gJkB9xUtxHqGnl0BIt37bDpM5GJQhjtiHkwDVOWaP0=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.11.0" "sha256-zGtX4wRie1PtMZAHH187+tr7sBKKDGI0rtmobYbuOMg=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.11.0" "sha256-yh1GVL7P6yRVE3o4mKBFFKhrXRN+7dO6PAAcdFENci0=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.11.0" "sha256-1HfybuUtT3ZPjOTgI2qOHZcXitlfzfVMFnHEvvpXYHI=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.11.0" "sha256-7gCktOrsUm6y3KId+7i6rl7QA5vGhPletY6gKyJdG6k=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.11.0" "sha256-NUmmtV2RcREzC030heh5Vq2LvHCfTv25NMefwIk6hfA=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.11.0" "sha256-ag+5kqW+j0c9MC/Ua4yUPPW72Gbj1LbA1QWG9CwCC7U=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.11.0" "sha256-pKLm6w1+j56QX+jxoywew8Polgeq4H2/xQpqQ71vQCA=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.11.0" "sha256-BnIdJmvh76xDITk+iEkoxTHeEBa9FZDV84fn1uvWz6g=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.11.0" "sha256-8f0vxVqWWdm8UYl7rtHBSDR5PJGd8bAC6DTopPUbdwk=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.11.0" "sha256-uZtrlWm1Hc3RsgtAzYf+ZY9G/G56fhbgxq0Aqo0SmIU=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.11.0" "sha256-fI/BuF5aulwnH2IviGqp4PPcIInwGrBNyghiCu4AGzo=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.11.0" "sha256-/eL7b7ZQp47BlLRGbxqwg6JnfYljXAtQOfRjnqWHndo=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.11.0" "sha256-WiWU20Yc3bWARmkbYnBA1Wy315vStIq16mLF4UHRksQ=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.11.0" "sha256-UtJadPx8k7JfoOXexAY/Sz6bfsrapCsdYtz0L0zIXxc=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.11.0" "sha256-Xe0Hn8XpfnmtObeKRtm0focC+s2eHLoTdERnDZmAs4g=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.11.0" "sha256-eJnuoN6ciE3k97/hLhr45ppWtq4jEpPcqpkZ2H+qd6Y=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.11.0" "sha256-cESQHBGUvT8saQhqNsOqSpyO7gIZmnAb2jhGO0kt5AE=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.11.0" "sha256-+r02pZW1xLqPlt5kHKrLXKFRwdSiHKWxZAxuji9TFvg=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.11.0" "sha256-dEqYpn7xF5JRzFgVANFeXw/ukeoduvI4LBOEwYwjLxg=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.11.0" "sha256-65luTwPeI4SHfJUhWLR9YJQwbdcB6J1ON6EBhojok/k=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.11.0" "sha256-A94x70FSnAUJSt5NM9yzhq4r7f2fsaHLx8oXeCq//PE=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.11.0" "sha256-Ze1Bsuw4fDgGJ8nVsRtmGQPH0ZPfxE+OUb6T8Q5hrBI=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.11.0" "sha256-upNbHBQLQVlgHItd8NuFq1C7DkM/1F1BAxESQevmeZs=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.11.0" "sha256-SKgVqVkHPX9ytLBR+yUpnVz82AGdxpJ+BLO7kBGJ3/k=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.11.0" "sha256-th7HVQIlLgfwYgZ3GFlYU5Cg5jjfEJbulaOaLFnQbUk=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.11.0" "sha256-s3VHCPLNHFHNYNHBzp2mhToY45+2bua8Wwy38rvNmjM=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.11.0" "sha256-BJsXT1lVo/Qfwc37nCGmxIFSN4nGtvVZZxOfLWDXj8U=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.11.0" "sha256-n5OniJhfpUA2ieVsaJasxyzV79sGG4QGR+bsy0XxqnQ=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.11.0" "sha256-KjhknFjnVlZpdKQQ7ggBlcTPEB/C9PKvta90oD84yTE=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.11.0" "sha256-gyvW6RoMv66Y7xIi1ak1f/9ivOFaNANQhgD08VlWGPM=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.11.0" "sha256-fK2BzOdlvbacOePr7OacTRd+XEFEAjq6fKXC4nOzZeo=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.11.0" "sha256-jri5DT8VP2J/mdsAR5uO+ZqZJdHexTiyER3tTAGLZd8=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.11.0" "sha256-wh39UKjVcRoFpHZw6es7/iWMSqWr793WGJd1K0arxU4=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.11.0" "sha256-O0UvfR9zN7G5VLXn3o++xj9NgPfF4HJfD22OiXjFV8c=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.11.0" "sha256-z97kNaW0Ku6kdWNfEpVUbQSMA1RBoX3ekiZ/IjcEzxs=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.11.0" "sha256-uIdbpjOfxxe0+LsrZAg/ygqzvCRNRbivyDMjoaEr7ew=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.11.0" "sha256-1J4uH1XM3j7LgXQ8kmuGw0MMMPMh0sfIjGl5xlKbj6U=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.11.0" "sha256-NXW9PwF9skgzZ8nRUEqNw0RoO2p0f7PsSzwChG5hR80=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.11.0" "sha256-/fKdFf3u1C75HiLoKV29Ao67+504P+CduF4BNGJObiE=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.11.0" "sha256-yfHcWilKZbtxZcJmrOgDJxMybo+GxvFLaoXSW0IxNj4=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.11.0" "sha256-vxc4o8AG+y0rA5yqadgOE8K3vCOLMs9uN2G2Xcq2vv4=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.11.0" "sha256-FgxQugrLHvORUMcIKJaOJ0/C30WOSRJ9gPbQO3nIQCo=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.11.0" "sha256-jc3/f4g5qKpgMhQPetRlfDv1Evh4/JZvzJaHSGhdAZE=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.11.0" "sha256-SUmy1ZUCcLMverR5FoyGowraVQ22xjPLc9P2fDFjIDI=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.11.0" "sha256-h/BcvTSIOPSN+RdP84UcPNi9pqvL+ITrxDNvH7X7/Pc=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.11.0" "sha256-QBleKtvFchbE6liuxlmCYm55VWLa0Eu38ydTl9AAPrg=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.11.0" "sha256-OfmohOrk90MjqjmSu+0xiATJrh99myqaUbirDpMj/ag=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.11.0" "sha256-gWLVnH0Rm3jlcDff0tUKjmrKqJswkXybn/BbyX1ogxA=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.11.0" "sha256-AIh+hTvPCxsQ1wML574FXpa95QYmcDB61tAL2zepZPA=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.11.0" "sha256-QdYU6pjF9r7fWbqGwKgmsfkJw04Dwyq3zYM/Ffth6Is=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.11.0" "sha256-aQ0jJkHU7Unez+DsVae9ly7fBXC8VYaA+euec4zHvcg=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.11.0" "sha256-Fh3+RnPI1DYqwRdiY5wphJ4/sa6phldf5Jw26EAy+yA=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.11.0" "sha256-TqW+JQcWLUkH63lmTSgM2RBpxiUce8H4sYhuBsG/y3Q=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.11.0" "sha256-SKowg/6Z+XkwRYvqLMVv2DNuqjYWDGxfAH9qDIfIYQs=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.11.0" "sha256-HKd/vW31qD4NxoP3tpCVrWhFxzUx3WFmpSNXR5MUGNU=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.11.0" "sha256-mp0wBISY78Or4TniwKFXbR/fiu5JWhEkccKrz14WlUY=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.11.0" "sha256-fSGb8vmEdIjvfnm60Ib6iQtLt3vhvGyFA+bhv1RLYt4=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.11.0" "sha256-qK/97mzT5xbNHRBU1d7lbPPhAbmUZv4A12UxDO/NHOY=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.11.0" "sha256-KJiEL5qkQAsF1aW42M0WJNRkmY5kuz+y+x2zhPl++oI=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.11.0" "sha256-+4ZC5tDNqIVE/tpdjgq0OOxz8nP3nnXuChBn1vH+GmY=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.11.0" "sha256-tgGh+wbiC5iUl89kqsPhW+ppYOa0el6D2aAF53e0OOU=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.11.0" "sha256-SS7WVEni76ixWOMMGkuVpvBL46kzEtc+nZVXLgVR7qM=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.11.0" "sha256-788nwZ08Yd7Jm9hbMtbikiekaCD5BJXGQizYA+C6v7s=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.11.0" "sha256-/DHba3kzpgIfMOdWDo9EqDTGsx6qliHkTcOqRvyqVQs=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.11.0" "sha256-oB6joxqVfw+dcdA1Fp/V3VqHKTV3AzSF87WQliIjZOM=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.11.0" "sha256-LKzrXJ3glGOLyZd+Cvt+S8d4kmqfJwDmWOpO8jVtZ/k=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.11.0" "sha256-/A13kQO/qzO1vnslZiMRgB1QWgF8ap0mZDFQzowOpck=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.11.0" "sha256-TY4kD0Fyb195X8vjFavszY4KIirBxdu5TsWdpcHvcqY=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.11.0" "sha256-XQID3eh3curqT6wBJ//7giHl+ALEMtdIhM+Ns8Bm3i0=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.11.0" "sha256-TiXil9jLCdO/pCFDUNIJpH2NC1TTdr9j+82Azgcdtfw=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.11.0" "sha256-M2hWm/UhFkEMaY/ZojmAgTHXYmwJUAqOyhn37WNwGWE=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.11.0" "sha256-mH+/ZBD/wW5KRCmt5Fmg6Bmd6svZfQw8NZgB89A3oY0=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.11.0" "sha256-jykGzUF1W5pVg5mzAC4J3EkhYgMNnXyyj0VesOyJfh0=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.11.0" "sha256-XKdSE4yJdaoaHoER/9ktK0gmSco5RcZNi0oAuSh7zVc=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.11.0" "sha256-t72a9Uy1pw/PgN80VR6aG7sgTE35EnLN1zToP9j9jcc=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.11.0" "sha256-60GCMrXfcFO/mDm1ThuHZIajDhWheUXR/FGdkRNb8Oo=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.11.0" "sha256-HEGUGjXjiQd0jkPYFHQ29ZN4M12Gy/l9VEUHnu/G4RI=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.11.0" "sha256-L8PKB1DfzGiKd5dEBT5EkxcR3a+P9wx5k4/J3yD2mSQ=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.11.0" "sha256-YtSwdniKZHpoOAfGy7w7QtkwdDuNtlUiiAxEraSMn6Y=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.11.0" "sha256-Vglr/xHMsRHm5yKu98ufddszmFtT0LeBVxyJRbZXzEU=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.11.0" "sha256-wlZo+BFJ1MfwO2gF0jKRf/aUNlU9PGL8BmIXnRY8mzU=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.11.0" "sha256-yehavKHvxjCDzDo8YB25tgKzmxAGjEtRQDxgHtaFxPo=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.11.0" "sha256-BJXDtvCyJK/LDiVXzgOEH8rnK/EhsC1i/wF7f4bcAgY=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.11.0" "sha256-fMM1lBiBdBpiEX9LCOtK85QDgiduht3tu3xdv4Yu/DM=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.11.0" "sha256-VmQrMq6ia+qw2Fk1DxZsHgjTNccY9LnOo855YEmFNKw=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.11.0" "sha256-As0IUtS4mDeiGRDY1rsz3WLURzIuvyO0/dKNGC7UvqI=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.11.0" "sha256-psuIC2nu/K6kLi0v1s5vhq0CCAqvuPy+E8J362qTLM8=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.11.0" "sha256-3ItFb+9nzA0hNEg62peBcYEPEFZVxR0Qa9z5vXfjkzc=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.11.0" "sha256-2Bwhic0Jag/dXemObH0WC5ZJR98VmE9lqLRKLOLyTZ8=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.11.0" "sha256-/cu++CeWRlZ54fD6YRH/qRJLHI+nKzCIbjAKYFiM/Ak=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.11.0" "sha256-Hco3i5jPJAzAsgKxFQP+MNRNNeiYfJCGIG8l+C7gWnc=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.11.0" "sha256-OhpF/CqFX3EkigzPqDIuIun2nr3F+gH0O+5hsB4jXWg=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.11.0" "sha256-Kw4ZzkV/dXvhOiPeFLJxdSJvMy1cTR+KpxTc56ejhQ8=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.11.0" "sha256-VE4bwmg1i9Nai6xGz9AK6gREkxSIBs3QiUCyR04O12g=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.11.0" "sha256-A4KkWqtwvvDSBdHB3xBdwmaC033AdMvoVY9yloXz++M=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.11.0" "sha256-tW4UvAdlX0edPquPSPxJU4ktMEXism8ghUtwZS6J/2g=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.11.0" "sha256-CIsxmM4gJ5Ds6FyNRixuTOrn2iigVWVjfOhnySLIC8o=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.11.0" "sha256-qY+Cr4xGjG2ULl+CTHwbH5ljGHJopNLfrbMdkuOI7IA=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.11.0" "sha256-MDGyOh+cwmUoNXs/bQNss5lgCzplAOVKcKC4djAGykw=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.11.0" "sha256-gQcy3oD2JDa/yncQP8wb1xl+WNDbQphO8YBQEeJ4BHQ=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.11.0" "sha256-8MNsjca7iVgs5t7v0zvIXV26vL6gKxXlGzFEONlKgHs=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.11.0" "sha256-XXf6dX4HXJGjmEvexMOTb8Pv+lF4bXJyKE44kXJwlig=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.11.0" "sha256-oOPJPa6Tn9+BrlTENXFhmvN/KI+0w0BKrKnmYbu6x9Q=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.11.0" "sha256-+xoCUWrwXEi8q+7Hm3b3kvEzXS/JymrP2fYJIPWLzRI=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.11.0" "sha256-F0hz9aHxAf/aHqhXsuA+mvHcFr/5pfVVKdsmmDW7rI4=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.11.0" "sha256-Ge3xhHySq3tXxe1JCj7hdaUjeAfzZkCncJb0Navz6Ic=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.11.0" "sha256-ey4rDsAWGsJrRECRbPousQb/NSGfwRRshWHqDrDBhqs=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.11.0" "sha256-6cDHUdWst+oatMZP9S13vySIyZUQ02GqRlfaOGUkPDQ=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.11.0" "sha256-OIZdgxxmfz7HXfZbRlzqK6x1aITXN9NXRp4LBxFmlM4=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.11.0" "sha256-1/YBIoqBgY1RPCrP/REd5iMYpqFXUXm3AFB6CfUo7F8=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.11.0" "sha256-Zlv1GzIn79GTgvtOe+4loAHXwDaYX1BiQYG3Fg4y9c0=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.11.0" "sha256-Zb5qmBxMqvuxczqOcwQCL7T4Ur4w9ESiWHAu+Wdq2zM=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.11.0" "sha256-O5is88jjNqe02YEXhxQojonvzXFCUW+YPl9DM5GmKjQ=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.11.0" "sha256-Vmtl3JWRi38gMtA0XEPObaROjUKjzv9LToWWOANx1Ds=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.11.0" "sha256-fIbCkSX6wG5J+IJQh2JXD6TtZOPTOIZQHXlHdVz1LcU=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.11.0" "sha256-kISZKBx6dlTqXUZ6PO3nlZzccw8daR1EZpN0AaBpcbI=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.11.0" "sha256-j9jlpZjefqX4sB5D0hnMTd0ZQ8ht+4rt9kJuAByBgGU=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.11.0" "sha256-DJN85JyJyhX3JDahAmFQbwoKbGR1oYvUs9VsPuiHcrY=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.11.0" "sha256-XCkjME0B8wKycmqHu+magBP6dtVdLRa9j4I9H7gwHKM=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.11.0" "sha256-xolmKH6/Ea0JGBF8ZnNGxG31SDFiGIP4+l2hq7CAwTo=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.6.0" "sha256-9iV7bpGMnzz9TH+g1YpPjbKBSKY3rcL/OJvMOzwLC1M=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.11.0" "sha256-K96KMoNKQuVzQMsBg8PC+Vp0tZCmkgjuWXHc//hlS84=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.11.0" "sha256-wneACGl4MR+jarW0rIqg15lHBFou/rnULzG2Jv8aI+k=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.11.0" "sha256-/RUFpcd1Jglx7Wxs74W7fFIPTbAVPhicCLfxl5Vtp8U=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.11.0" "sha256-Zat6MDfQ/rCSB5Ydn7FPO8LMKl2wRNYZCpVKoXLKrpo=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.11.0" "sha256-hxGI5jMrscgxIF9Mke6s7tM0CDllDM4EHU57Q/EdK4Y=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.11.0" "sha256-FiTsLALc/FvB4AsDWThiHfC2+M/J9mrS7GixrzqEv/M=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.11.0" "sha256-aOvnThGfSamrhxPypI7MKIwd8zEMuhw/o/UeGxZmmDU=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.11.0" "sha256-N1EyD7esyQYNdEk3qWcekH+/kpebR9kCgkBtiBuTLBU=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.11.0" "sha256-5P2n0Fgk2ESOm99uEdgZoe+Sba20vyCUsJdl0n5Aylk=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.11.0" "sha256-Y8+aQARCeYuIfuxLU31gjY5NGbp4p6Hpamgn0XtyuM0=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.11.0" "sha256-E1L7Q11HLXscHOrxPss2fRNjEykdQRa28yKmGzvgIk4=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.11.0" "sha256-/ukLk4kKSVtsJ8MNXw58bn6l+0mlAeDPVaO1EwiD9oA=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.11.0" "sha256-JSGf1XwnNTVEEQR2KyI2krBqSEgEFw84IR1gdrdPdi0=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.11.0" "sha256-fOVxWpaqJVa1sjhEm4ZzgfdnxIQlIxUeORbLG5a4A0A=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.11.0" "sha256-YVcmN00t47DMu1L9toL4D33rWPfqkQa190RZJ9KcEbM=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.11.0" "sha256-8A93fS8hGK8DMZB4t5fK68PDKzxrYmVDa+UCkhhMUxA=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.11.0" "sha256-PqoT60G1gxTFoIx5ro2Q0aCnE9wCXTz5nZO+CVNzUKM=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.11.0" "sha256-YbIqecsNgBdG0ruscwRiPhOQHmejIDopHVDG7RfeYxA=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.11.0" "sha256-XVJ6Te10TqF8y9+A7GN+fD751K4twpLvA4SmTSqc10I=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.11.0" "sha256-XG1i5KepPmHiuCVPBK7YeQCEIM8ZqgnvIqEtcI90xN4=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.11.0" "sha256-pPreUhwzaK65rZi/TjNX+HMFYF0pr53xKKrL7euxX84=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.11.0" "sha256-p3SLJJSU/dwGtZxRacLBVIagJ0b52j+IL4Mni2E0pVo=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.11.0" "sha256-cTPED/zwtypKNxX2s3ZkOsVhGNvCRs26REiL+1EpCgI=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.11.0" "sha256-vshDzMpLr67eVAXaQIFXk+EbLL9rnw0qTQDarvfXMk0=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.11.0" "sha256-pH5VdrjZbMgaPIzDdG02aUvTzfuQAVHt++Bf7V5pn68=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.11.0" "sha256-fSlti+/6WF21b7wO24zK3PC4eftPnRvJM6MqFWMsnRU=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.11.0" "sha256-Nrx27vWS8QFcWGQ0fE/gUwbwJ8mj3seWnuauTuJvVDY=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.11.0" "sha256-Rbw4qP/duKCSEvQMeGLMrT0dBiR9tTqzt9BOwgX0QYI=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.11.0" "sha256-NNZk/u0xUBPZiWFtnwZRibnTVYVfHYFCBz4wZIsLOUM=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.11.0" "sha256-x+dKJMb8cpGyFf3L2ErOrjt2xNEg9gasDbbdoVaTYSY=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.11.0" "sha256-r4uPC1GPoGvoIs9+lJW5rjhgKSI5hJiTKBd4lpCuVxk=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.11.0" "sha256-NUH187B29S4bnOdiJHFUnpVPIZHuf/IJ2Ejy4yZW6r0=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.11.0" "sha256-Pr5O3c/zjCwBNdw8t17Rt5yrfeJFW9O5HvUohh/Xza4=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.11.0" "sha256-NNd0gsoQzqZVUYYncNoqyP6OMl9J+ijBXKuApPiqkFY=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.11.0" "sha256-RD48FPh2hh9A8Q2KdFkMGmqE8mzI5eKhhYFaOIo+tx4=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.11.0" "sha256-IRhw8nWeCMzviscWn0ksaBcuW5K2Ha5S/zShZJ5RFw0=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.11.0" "sha256-kfOtvZ/f5awN9x6Npbf6aMFcm5UlzlJiBewaeBsuRjo=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.11.0" "sha256-w9RDhBEeUPI/w3ZdlVUR6MkUQnh8lyJB6k+5txpS7TU=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.11.0" "sha256-gS3ehhl6Ff1py+SNktpEbfzCyZb0hYqpgI8IBr5zyug=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.11.0" "sha256-8mM82WjPweo68zoeDPG+oBPaukE7HdfqNAgzAXwgEmw=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.11.0" "sha256-ux8BoOOyqSN9IQGapfJMrAF1hOKQ2VnXUQtjWsn6Rgg=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.11.0" "sha256-qqT07tPM/7SUrMCzjJ1LnF6/q09+MjjdpClU+GEWOPY=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.11.0" "sha256-Q9j7pWVHEsO94u6YIEJxpjqgGsamHGiaVUMR2R6r2EE=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.11.0" "sha256-8cSzwbzat/TVgRGca3ASOM+BkxkztRKKWth5nWoXwyE=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.11.0" "sha256-yYVAiUmpQgeeBGHFsjAGK1VrbbjOsQe82uq9JYgYnds=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.11.0" "sha256-rdX7ZPvQBsmYDW/w6BD/e5O62FZ1RClg0icPnIlr8DU=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.11.0" "sha256-Cs8FzA2hr4ZKLc5OVAtxIG46+yrYtSUwi8QHXAlkBD4=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.11.0" "sha256-TuhN5P8g8bFPeM3V6vqd5uikG5tDcmhxx28h5d/bb4I=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.11.0" "sha256-lBIa5TTvs10qxZX8v/Okkx2bNByYtJu+wqQmH6oPO4s=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.11.0" "sha256-U0XmJlt1SAA2gsOB8uPGYci6xUxRCEKYNkEubZo0sj4=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.11.0" "sha256-m0+AuxYJ4pkd4+vvIDbL00wky2+ni5ct7b1+G4TmorM=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.11.0" "sha256-4d/xpDpgi35aYBw01TKs2HBtQlTTYJVogLiL/o8b6dI=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.11.0" "sha256-v3ybODPtGQ6gYb21EDJhTY3z7y92lsk0oFzsr1KjSjQ=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.11.0" "sha256-Q9aPKenHsfsdak1rrJ67nnG6qqyr+sQBxLTYN0Hiccs=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.11.0" "sha256-4H/KRmYnp41L4A2nU1h0DEmEDSZlxuciykDERYGjt70=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.11.0" "sha256-sfeUFQBySYHD8m21P6UtcRxQi5TqfSIYgRraz5pMXL4=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.11.0" "sha256-ytU6H7PUtQXvxECRLYAc8VF344ttXAwmhCZyx+pPPLM=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.11.0" "sha256-BgGVEaDqaqQGZMMKNjlZ5AQvoQqjyTwrXh3DO47GKZo=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.11.0" "sha256-SePLjtNFOw0io9+IF9TOAZ75mK5LTjFqTyu9zgMIXII=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.11.0" "sha256-Nvngx57lLhCHJe1J2kW9giuVqVlDTWt2G0/V+F3qhbQ=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.11.0" "sha256-sogBe6kjxz5m5pWuMyoDnxAV57W1sLPa2hGLpfSBrx8=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.11.0" "sha256-qF/6aoOLZ6s9L+kemCc/F7+d0AgTRlfQws2YZAi3kVY=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.11.0" "sha256-w5B+PvK4s+oQN79qTBCp0FXnPNT9WqFuUHQEzPAamCU=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.11.0" "sha256-D+loPH8h5FX9Hu47ITN10TleVofFJOHfid+GjdpL3mg=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.11.0" "sha256-EJ3cdEwiwcSorBLVGol94HKFyD+ChDBhPjJ7mnA32e8=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.11.0" "sha256-kuj4ZPqhtW3O7jpPEHwuAW5JsySJlyeno5P+azunwl4=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.11.0" "sha256-oz/Q5mpo1K9lX8M9JQ9vI6S1jxCpF/2MIZiecN46zAU=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.11.0" "sha256-JIUQzdIxJHbzgELIy+EmYytNvv4efsi0YL7g44VAEk4=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.11.0" "sha256-KPyxVo5foHyKEMpjT0Su3PzD45TUBEb9FhcG2k/YA2k=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.6.0" "sha256-gbl7jEgjk4twoxGM+WRg4MZ/nkGg7btiPOsPptR7yfw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.11.0" "sha256-sCwedjPAwXdID4eCENDCbqqazrNFemM9OodgxaXqnas=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.11.0" "sha256-njTF1fiVk8VezuzSRPNgA+HYZ089cXFTiGsci/yJ/RQ=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.11.0" "sha256-reshSY32SwJFCMiT1lifRqQkxofXeDGwiEuVc+sA5jg=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.11.0" "sha256-WM4dEyBqocZmCE3iG72SN6kR9u/InT3C2YY2PVl3drw=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.11.0" "sha256-HG7VV4MGdVbqNuLqM/es1WoKURm16hEI6soGUcTEOHY=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.11.0" "sha256-FFe+imaR9rnLakPlGAZu/oSY4A7s/BO5InYKtkRx77A=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.11.0" "sha256-UOJmvsLMvq2PlCvWstIGs3sE8JPTYSsFY13xFhyLIB8=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.11.0" "sha256-a+t4nGBLASBOZfuadcF/VRMpekjOyfiZXl81vE/ZfO0=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.11.0" "sha256-/+T6CRjrWy7ZDRJrqXB0urITj55s6OeJD8+BM65dMMg=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.11.0" "sha256-BxuwoFU+HEZDzh+PjmVK8NTqeBDMIThibFN0EMFwfTY=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.11.0" "sha256-I9QfN8izkZyhtx5jlSCCKKUVtEqSXrTeXtmEvmLZU7o=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.11.0" "sha256-Z4QKqqeXtw1FihA9bJuUdbfah0bpUkuF80/MmMecgIo=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.11.0" "sha256-qpYMY/8FLidczmsGyurHHZT+gGq69GNmYzZOI1Qo33c=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.11.0" "sha256-b8wIvWFHwQPwoMD3rsuQ00nNPvtGK41zlqTEsnIK4WU=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.11.0" "sha256-l15NK1qBbxyTtSVIf6tafpn9ORXP++xIntIvfoJXMmw=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.11.0" "sha256-xauRwOuUy/b0NolFHz/ieBts6rNxfJKW7l/kap3XKKo=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.11.0" "sha256-P0kuhYy6Eqfq2E4Zk1bJWIziNSdB42hQk4MnuGMyKNg=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.11.0" "sha256-GyF+vCtU16QqjNX2CYCIzFDnOCkjDpMBYNnBx7n5uvg=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.11.0" "sha256-eeXyYEsc8+Z50Fi5BPXQ655IWnRb7V2ztUz6Dg4Bfl8=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.11.0" "sha256-DosgEjRG1Yb0T8veRz4MhWtcNN7yeRAKWp5C81LKPJo=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.11.0" "sha256-D2U7NuLrjBn1j0NOpITmocfx/YVdqNZoZpLYpfk/5Dg=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.11.0" "sha256-5xOjAO88phwD9WVgZBL9C3x9soNPN/45jtrqn51Fd2E=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.11.0" "sha256-K5EXiQhluhNWYEnwom9E5I/rmrUv17CknO5ZVY5Dxig=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.11.0" "sha256-uHg3yqEdNpjXLGPOX7JBDrYo/uxwc1M1pdBd46H/gDw=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.11.0" "sha256-e5dVP8R6EsEygjpvPZnfcapj0kqJocsa5aL4olZZrEc=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.11.0" "sha256-dV1OwwWzWauCnF52N4JtpE01HzYPlCxsTBAKgFu7Czc=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.11.0" "sha256-QLDpZcvPwW1OggflukTSnhgR+l1xTeeepLuwdzztMCk=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.11.0" "sha256-x7p23ZzGvdJn01XEGWTSjx+HX/QUicfLiqMGF0ZV8Lg=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.11.0" "sha256-Wg12l88mDmZuXgxZ+UFsdBVbbt2I0Nxxfi/2AH3QARA=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.11.0" "sha256-di9s15+U+nsgG9a5WTajYyucCNo86+8Bv2BI7OWGXQE=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.11.0" "sha256-2sGnCprlQQ00g4WjSu2N1CuENwyfGt+P/i5NfKd4Feg=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.11.0" "sha256-d4cjbqZRiK3VpLY7jxureug+nBtCTVQ2OUjXKQLufZw=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.11.0" "sha256-lTKQ1xNAy9AqyPoRuk3ThwlMd4xlFjtm3jAcZjLmKCs=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.11.0" "sha256-ZB3c29FJiopBwP3NcMGErMMJj45IcQ1KnDFWXePaI2Q=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.11.0" "sha256-hNs5/R/dSV1GaNj83OMIYRiqmEsTHQ1lVjGqFqvRPBo=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.11.0" "sha256-aum5y7noTMkaTc7Diz2lzlkqLJaN7schCQAmau19vAc=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.11.0" "sha256-QcLO5rG7Q+55XRszr2vNJsSkXamYvOEe3BTnsu8adzc=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.11.0" "sha256-t2K3hypn4E1sVoQn8JAIUuycQ2lizBXokpz4N+2XgH8=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.11.0" "sha256-fGyv3mf9POvGFB+JpHldbxMfi1kUiS2YNkpVabgrDIw=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.11.0" "sha256-c6XSyeAa80f5TnoyMvsAmqESpqaq+y94sfRXF6cFpt8=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.11.0" "sha256-cQNQz1xgCbLiKWR1i1sgDmc1unP+7IoF1c6ZwH1G7SI=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.11.0" "sha256-h4R5ErD7YDqOYLxRgNioB4dhL9b+OwiA38AM3EoXapE=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.11.0" "sha256-VgJWOfWEdZI+9udvORUBl+cbAlBAb2YW3+rqyqOIGdk=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.11.0" "sha256-6S/4awBPSegC+GeEysxFmne+5K4I6UlQdnnK6q/7kBE=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.11.0" "sha256-k78zJdv3w79v1ocoem8d1VuBKTga7iPpPYUw0QyjHkU=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.11.0" "sha256-klAYYRH+DUBzs/JISvYAVNXedeje1yhyd80FASAOwzk=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.11.0" "sha256-HpVZnkJvQgK9Mz+J9ZmJfDGoj9REpZqFjJBkfkvI3Ww=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.11.0" "sha256-icSP1n2t7qcZAt0EK6/WK24T/JJfNzFzxmX3R8KMqYc=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.11.0" "sha256-UNBJarFF4t5NjLKLqdYbr7d+LPqanzZz5HtO0zr/hzQ=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.11.0" "sha256-bxmMClb6G0+/Sc1c8YrhmPpTlfM26KiFxfIiRXm3zwY=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.11.0" "sha256-0DafiqdMAXbuxVXg8vz3uHuiiDANvOLAMnClSt6yglY=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.11.0" "sha256-QRtJLMtoD7m7p+HPYzpPsaFapejDGjHPrZDFTbfAATc=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.11.0" "sha256-S774aDCAbVL40vFcerr3IrO8jejU3oM5ECTO62PvK+8=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.11.0" "sha256-h0MgZfxNlzEnqgN1AgX2mEbN45O+RToVEyEaM4SUrnA=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.11.0" "sha256-EUXjUigF6Ntifj0QGvEo/i99lZlIujbxNAPAJTCJi40=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.11.0" "sha256-mnAD4olYuQG1hIurWbfWj8yVZipellgH9werYLZCVHc=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.11.0" "sha256-MlK0fPBPZzHheJ/oaL4ficKVUhQnm+ERN3G7fuqmG6s=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.11.0" "sha256-DqdxwO+VCX4eqcecT3kQSaUZa0XWJHICKeqE3CyuPOE=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.11.0" "sha256-81KbDwWUcjY7frYXgpH2o+U8mi8fMxP1X0VzFUh7o3o=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.11.0" "sha256-riJj0umKScbQ9MCV88fNeHiuLcigzJqtWRgIhcuI3Ww=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.11.0" "sha256-taaVPQtZfF1L9bCSL0ppyGy8YZE4pvJA2hK0YAcE2Oc=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.11.0" "sha256-nm1s53U2rmuw4Ko21DOW11neknjfBAyq4S0dBzJQRPc=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.11.0" "sha256-UlpkN8g+rBmf9hu0MrWTaH4S1SaNQK6mFeBw65hF4Nk=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.11.0" "sha256-rxdvCAEeoUqduN/56yMNxZnfadedkTaPpg7+XJhcHGc=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.11.0" "sha256-AHUOMZn6kUKnY9BAteySrzFr8KC8kE3nolHEZ+gn+Tk=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.11.0" "sha256-YsFxhXd2xxW4vT2zDCHRCzFOeINKL7JypENiTcoAJ+I=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.11.0" "sha256-IuaCCYxuLrrg6JPQQD98EiW/VSxs9I0Aidiv+UDp/ow=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.11.0" "sha256-9hVBbXOYT+qn6JwUJyJFIsMemvcQ7DyxxlbBKxtTyIU=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.11.0" "sha256-rshRL2vH9hHEeYbWbFlnDkotiQezo9kLIjnK+Kioocs=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.11.0" "sha256-yyoFe/7AqXu9H1hZs6yfTGt+d+peDu1GQEWQ6+G2gfE=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.11.0" "sha256-v20pt5uv3Hj7xek3Xm8X2GLkRk+vRZpqZSENLOYx1hY=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.11.0" "sha256-qCVYQmM2F2uYY7+LbyrUGaFFf0/s6wyYilwrHckyPag=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.11.0" "sha256-2s48UBjDJqtQ1iBr2yV6rvqoGNsLBpNaEP1WNsp+qPg=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.11.0" "sha256-ci+uWwMNglRm2inRUzGtX8F27Bv2KaRZNNjHxMT+gnk=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.11.0" "sha256-e4jmows4W8JjUbBr0LhteSRp/V8LBk/em2SYWFTHhfk=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.11.0" "sha256-mK5CXukLRr3978LJBAHn/KWOxiIf8zpBZ1ETiXIC/9Y=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.11.0" "sha256-ISNRJ5/A+/QzuIqWoRQEnPeld7INZGvTcuqfQWK1FJY=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.11.0" "sha256-TwXt40LBCATVrunDjm17phBbcpMHU8HkWQ7/avBozvo=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.11.0" "sha256-kxLh2DKFccRxmD2uHTlrf62qasZ/FuRQOLjhzTa7nX4=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.11.0" "sha256-jCqxuCWdgTbV+ul+vtauiWaA/cjiIpbjlYRrfaV6zQY=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.11.0" "sha256-/jG0DPAYhycTN0VKAO2i2EO4htRnLMbUHwLxND5SiDw=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.11.0" "sha256-287Znbh373X2EgFilTvFjQMYI8ol+EHmMS0krMsCMIo=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.11.0" "sha256-X//a8jbgKvgYb10yLsha5Ekw7JfBZ4ZJDpZtdj8DQy4=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.11.0" "sha256-SZO4Xo3+xZjtHGKCWMgcV9VgRkFsLEEqzWq3uKul340=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.11.0" "sha256-fOqlUtOyJR5EpBc24tJwRJakp8OpnoxIfQgdEFlFNjw=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.11.0" "sha256-SCfymFM/imhxod2yTR4wWrm+bNQ4Ey+3GhXND1pigwk=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.11.0" "sha256-vZd4RpmMnviYbcEwAff0DmMFsIcHiYV7to1K4bgP8D8=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.11.0" "sha256-+4g0HkfkBA2Vi7VHUJEWRyShCVool+21bEpn/t9QNUo=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.11.0" "sha256-SP4nUssP7jYS/huBwNf9vVcBKBKSH4X0jJEjWXNC3Fc=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.11.0" "sha256-e/NlinVQRHRIEqdN4MeK9yD2WkBMgIZazrGvfsXLiWk=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.11.0" "sha256-a1yu68zlG6N+ezicX6aLH99A2kYLNCPV1cXMYEeI2ok=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.11.0" "sha256-Q3t3g2FiolXVGGlCAodY1dweI9WlNaYESvFLB7vzyCk=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.11.0" "sha256-bLwQkmNKbuqUyKh8QlVDsDfx1pcgC78K7B2vumrJZNc=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.11.0" "sha256-giit/TrRCMiaT/qJzyvKFS8dGnJh9VrTw4CRv76rXVo=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.11.0" "sha256-yZw/D6C+Cj/du6j2ii2muxXOp8lrpXfPgZp0xit7uyM=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.11.0" "sha256-5nj1I2OszOyuSvZtEnfrMlPBMmTrI4S5Qf2PK2aSesQ=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.11.0" "sha256-UMEnin0Gc9CRacjlG1e3h3IWJCrp4EsewTzk1GFMjck=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.11.0" "sha256-vhu5PJX3NsaG2BXy39y930Bf+70zV7EfZpqlCbtZVhk=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.11.0" "sha256-AEb2dQnJ+QN0FAbDtjYfAwb7ZAeVqod+NIVE7iBVvBI=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.11.0" "sha256-tVSi4HLeb/QiKs3uLfp19Kzuwi7BspYOh8W8xa/yjVM=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.11.0" "sha256-01wTzG20lsCat32U3ewxYNUxVbHEJzLAxnodJRIqGBI=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.11.0" "sha256-kJ05BDT2EJBRNmWbm9PUY0yh5H/PHonvIvQQyHg6Nak=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.11.0" "sha256-a/BkGzBQLhgQmPdXQx90VSxLgrr7wVitI0zeefC14vA=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.11.0" "sha256-vsEfls5Rf8vWb96jB1WTcAwAXP3GDIkmNwL+dEhBlJ8=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.11.0" "sha256-ZE1VA2mExcHfHwJ9pIJRlXeV0NDH5Lkvm9yOS+nDFoM=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.11.0" "sha256-MzlJ9CeaHiwEKd+miQO4TdIr9JG/u1XW4P1l/kGVgkI=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.11.0" "sha256-k6rcuFumGuas7qOMa5vhp6rfxK+J5wWq47Gwfo54p30=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.11.0" "sha256-l9jFLw3A6yIQ8JsRJO66CUetSeitYx3hE1fTTAPCKh0=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.11.0" "sha256-sUkTUxkwSClz09NZ3TxkKyLUWENJt1L0on4Nva2ZQ7U=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.11.0" "sha256-EMZGeA34sNVNqv3AJSabyz1HoMbic617CQPp8O2droY=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.11.0" "sha256-651JlGJYbt7VAdIkk57nxH0PWvi1voTruVzz8tC7rbc=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.11.0" "sha256-Np8fPiIjW5F+co1s20R3hDZS/fb8U0pYoKNC1hzEQrU=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.11.0" "sha256-EXqbUM4pYsmprvd04fDghy5Sy8u4jgP+OWSg7sWRr1c=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.11.0" "sha256-POwMTLFUjTNa+nLi8Fxq8UihOkX0z1NuFaETuI6uLns=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.11.0" "sha256-gEIBYw1ncrS8R6bSS5uMCpSGMpDvItAyeXuMJN6vsi4=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.11.0" "sha256-6HCfXbZ7hO63x+N6n9jA48+UshaHgKHsvEGYgZh2qAY=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.11.0" "sha256-mEVJMqWKv6u5Idw+stqcTcOB6RVOfExMXYnuuExEhNU=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.11.0" "sha256-m5l6ewMNnOnDUN9Y0h5rxjAyaO6OZK2BdzxXM4Vox3k=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.11.0" "sha256-hv8XkRsnIgvLGr2XIjyYm2upv8Vj4i42UF8BpKil+S4=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.11.0" "sha256-m92lE8qaVgwKQFA/gv9saL6a7Zey7MtO9dzGbahVx5k=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.11.0" "sha256-LPqXAPzwkTt0maMEyZE1JTYVYzxEeN/ST7+B6Fbw5dk=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.11.0" "sha256-t4Pdd0mLzw08rWQG55Sz5rHJJApuiVSBDyT5IejqlX0=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.11.0" "sha256-PXigzc5hHwKFKzGf4UHMUbX6Rh6DTdm+Rh74O+3SP+0=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.11.0" "sha256-JkWCjmi5SWKdwqnNUUW6t8iGwc8NjWoQQUQo1pCqeoY=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.11.0" "sha256-/KrG8QIZkSKPGOEe4nJlCzdgvdChKU5Xrop2JnUkdGA=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.11.0" "sha256-u2O7hDKAVfXcgX8JY+m0WgeEwoCyqfQbwp5xlfUSmCk=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.11.0" "sha256-/+7mljg9y9FMwwbJ8NYi9k7bs2fxsmhR9Vvin/Y2JJc=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.11.0" "sha256-N0FrmOkrt8aLx4tfzAmuwRW6/oy3XHVRT96/IXtSUyY=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.11.0" "sha256-c53Wqgux7PN4xV7c2/nsksQkDQ4wI9cXcF2QLajNqC8=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.11.0" "sha256-Sz2Q9OPDWeI5i3F4vWbcYqjoEsnclAYUu2I7jIJA4KI=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.11.0" "sha256-JUIL7o1dC8slMcUla3NFPsjSAy/D2RjTNcqJY/1a2VE=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.11.0" "sha256-BiRk9QfVBLHQTfq3v6QdZAVewO8QZvTQl1ARcnEouao=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.11.0" "sha256-2UBVBsFZsk4Zo3JNo9WThqzY8SUaEecMYD0c05pd5Io=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.11.0" "sha256-c0GwHy3OHQrBMLhxyIaKPoHvtF79ySSL//NFOngfeL0=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.11.0" "sha256-MqggOwWPYz1wTDvGL+64dukGHNisK1S/ZJnkec9WOkc=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.11.0" "sha256-/+83iitPdMoKHY8sbYoBgN+KtMd3GjcBtiBdM0vnbbc=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.11.0" "sha256-iEy+2H7bRE/kbX3EMpdLWu4DYMNv4ksyfANaY/Tc6x0=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.11.0" "sha256-MSLS2rEhdAHWxjdU+ZRWVPR9ZtAeMcwyifULhx0CTno=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.11.0" "sha256-A/YgoRKpFSfE5/eu2Gts1u0U/p4D+j2xLXa2fU+f1Kc=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.11.0" "sha256-WTsE8VJc4EWTA5G/5B7mHje4VDZCSbBsFxwIDkExq2A=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.11.0" "sha256-Zzr96zjueB5KT37r0feaTj18kd0IwVp9jXMjsIuWhCE=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.11.0" "sha256-p/WikTCNYa/Bwv7PXOKzsHX5rBBtquKWf+RPD5fnbxE=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.11.0" "sha256-CqBfDmR5WUUTK0jH+ihiJpugjEZtY5zvL9hZ9Wk+Jy8=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.11.0" "sha256-XEbZfg7jxW9PwZdsQ9XzY3/i2DIV9yUBlaCbubDcFjU=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.11.0" "sha256-nNQ7Dq1qENRdoIfzVULZZ3JDvc6EEMJF2yJO6iXCMVg=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.11.0" "sha256-abkID9Xww52uDpNABuUI9v3fknUNBkZ+fMjAr9mWv+0=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.11.0" "sha256-57+QvrdJTJK9psRohrA4HfPuTVy1AKVK7YUWGHOX0jU=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.11.0" "sha256-xs8/fAuglhlUQcHKC5m+tbkjYKvN5EEUQV7lzrnaFUc=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.11.0" "sha256-RvEVbetUhE54iLlEvloG5F+9tkmmSFCUgwoXVRSDfX0=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.11.0" "sha256-COUTKrzFCLI8VSa/MBNPAeBkgGAlhBvOayyYqnYHaNQ=";
}
