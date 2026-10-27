{
  lib,
  stdenv,
  aiobotocore,
  boto3,
  botocore,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;
  buildTypesAiobotocorePackage =
    serviceName: version: hash:
    buildPythonPackage (finalAttrs: {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      pyproject = true;

      oldStylePackages = [
        "gamesparks"
        "iot-roborunner"
        "macie"
      ];

      src = fetchPypi {
        pname =
          if builtins.elem serviceName finalAttrs.oldStylePackages then
            "types-aiobotocore-${serviceName}"
          else
            "types_aiobotocore_${toUnderscore serviceName}";
        inherit version hash;
      };

      build-system = [ setuptools ];

      dependencies = [
        aiobotocore
        boto3
        botocore
      ];

      # Module has no tests
      doCheck = false;

      pythonImportsCheck = [ "types_aiobotocore_${toUnderscore serviceName}" ];

      meta = {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = lib.licenses.mit;
        maintainers = [ ];
      };
    });
in
{
  types-aiobotocore-accessanalyzer =
    buildTypesAiobotocorePackage "accessanalyzer" "3.9.2"
      "sha256-s+as0Y5fIz9o2bQol7dpvDpOfk2OaHiktkw2JCvZsxA=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.9.2"
      "sha256-+P1ULpvP7vZJ5c0o5spc/jbazwQQlf5iN8doo5OzRU0=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.9.2"
      "sha256-lbMflCVCdmlOBgo3bMlPI+7+2SkBMd7MdEyF1/+KWyg=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.9.2"
      "sha256-xMFA1tdSrz+AJ2z67s2HOR2oZJTZVywdACzsJGDkzV8=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.9.2"
      "sha256-TjuBmpkwDJ7X+wp8XP+LdDO5eA9hqRbXJILk7ZbeQJM=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.9.2"
      "sha256-ATiQvftoZTyCgTuUfKoO8DUDXrVWa1bJHKsQ7dnkyuc=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.9.2"
      "sha256-8wpTeB/tBcP/7JPOxNz1moZipnCRJJ0rjzbSQpJpZ7Y=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.9.2"
      "sha256-JsA2Z+IiYjUoZF7whvJZ71Cxeqxn0AyLbBuB6pnaZcQ=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.9.2"
      "sha256-TVyTyNzGF1JrsBKDQZb20sEJjf8v4h4+Q9tGrd1QuOM=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.9.2"
      "sha256-kvRRJVbA3vHREwsLx7rXY2HF2l/VHB3OVX7PzXKmDh8=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.9.2"
      "sha256-PGidfrihDEeciES81PUe38KDyOAHzpuBHNFdG5HdRVw=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.9.2"
      "sha256-Y6rbMXOCBElKPPwlwSazifKgYBFcqSKEjmXIgmIHWVg=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.9.2"
      "sha256-U8r9HIJRyTrxwgNrQ94O/WOWfvbCNmz4HSjFkGwKtLg=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.9.2"
      "sha256-p34VhjIuFgbbmEBj6KFjbDHulPTma01ndX4c5aq+9f4=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.9.2"
      "sha256-F6BS5CH88tWlCs3ccMA+DqwcgqZblrX448BHtU4Vd7Q=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.9.2"
      "sha256-tDN+MQw11z1FPaXnd6eTWGFc280aUjbPBCXcFA4/Exk=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.9.2"
      "sha256-QopvHewNX2OmsbUB+gYRsvkGUjCWOoBmvOCEMaOTcWo=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.9.2"
      "sha256-xQEpFND8LNdvgy6zkWkqzMOkBNld+bUeA+xYTY40hYs=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.9.2"
      "sha256-BbRn2lqlfk6lLyb9akzSR3oioBWH7UHWFxF45YPfBeU=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.9.2"
      "sha256-deqPeOqJAPz9HcxB/fhaPY2A1n/sTnbDXK4DHNKYsvI=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.9.2"
      "sha256-FL1vQoxVdCqczJ3GjCi+FbQFSw4Abmw9UtprCHxgC9E=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.9.2"
      "sha256-3+O/8Qvr7jOD0ggRMeEH8PT1IQ/cr9kabROsng1iihs=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.9.2"
      "sha256-Nw4VB19Snkxv+v+ZLOeu3Od+sZCZX3avo+qA7l8Id9o=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.9.2"
      "sha256-gk6wtiAE97xZYvPNThzKrPrkpp5Ux0WSAZfjm7ZtLZE=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.9.2"
      "sha256-J0rG9efS8yqW06Uvx5KeXMpmv5k14/gJEJeCA1JLIGo=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.9.2"
      "sha256-CXL6MR2IZ6sjkq58zIICQ3l6xmSF+6L9s+zlz+RPyEY=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.9.2"
      "sha256-zWlWIZq8CIEVn9EKjTpJedbcOeMCRifiBPlYi309ew4=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.9.2"
      "sha256-qfb9Qh47UlW2/kS5ryKoQVu1T+A6OvM7+4qD8bwAp9Q=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.9.2"
      "sha256-I7LGrf8hYlBuvYq9TzSGxhBXoxHLwqaPGZEjR+pLdEE=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.9.2"
      "sha256-/U8tHd0+fBa9ZqaprJgub8hG6cDuHbF0a+5FDJ0aE1o=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.9.2"
      "sha256-z+WdJqo+Z/79zo55WF5WfHzan8lNNzVlvQmDDFlE8Lk=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.9.2"
      "sha256-CBUgP1vOqW02lKvp+JgCyUcch1ojhVvGl7binAdbJio=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.9.2"
      "sha256-EZapKk5elZi42z2XINVw9IPBhUeWpaxtIHfhNGBMjAI=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.9.2"
      "sha256-BpKc8lj6PCA0LSG28zkag0T4AhczttLXTUtmwKsJ7ss=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.9.2"
      "sha256-E/GuyQVVv1NYa3/i4SJOyujkkNqj2f8JBwgcAkdOlr4=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.9.2"
      "sha256-9C59R59JCXl4JUO5uIRzFg7qEq4GvlMOcygOPlircj0=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.9.2"
      "sha256-tGOBTPa4ymY1CVU95zNTJ78mi1guJCxJOJBNqHDRkpY=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.9.2"
      "sha256-JpBuxs6Qts7kfNvBZqRP2YH8mkZVg8EF7VrBpyypLf4=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.9.2"
      "sha256-Pl4b6kA/xHP6VOmt/XyrC7k7clpwBMoA0dlqquJYPLI=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.9.2"
      "sha256-xyasjkgj8NBWvqFnNaBftHYvWM6vBE8zna53HP1nYpo=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.9.2"
      "sha256-np2yWRmaw12YxrY9LkPbjim2//XKnVri2wXLKankbls=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.9.2"
      "sha256-wxAytdNZbuFN7D3tRhhAw8DYn+aie/smkLhpwL2ct+M=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.9.2"
      "sha256-/S3twqgpf+u9CvXr6tV22LA9RB/pD+ChW1zQoixSfBk=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.9.2"
      "sha256-nwjPHriiBtJAnLvTYixib3S+wD2BTogIKhyjaRJCJAg=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.9.2"
      "sha256-ejPoxIVwkQ4i6HVeSEFja+xEEZInw2NraQAtliaCMHI=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.9.2"
      "sha256-McpLsVIq/f0NBsTAPtzeWK8Wm8YMplk0AgQSJIK1UUM=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.9.2"
      "sha256-K7yprU8eNPHqqARm88M+26KMjl0F0DZnkAstWfKj1K4=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.9.2"
      "sha256-WGn8BnSrKoxoUK/aTUSPO12WLegdwWavnrdJEjYpJj0=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.9.2"
      "sha256-0ydEwPrYgbCyrScRpeIaxcLgdp16BKMznZ5EaWVgi2c=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.9.2"
      "sha256-7bXJXRUmGL4Ld2HFcU2T6R9YGeatJ0T9NbqPK/1v9mQ=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.9.2"
      "sha256-RlmzlhNGKQHWKDdSA0yydOCjOXXxpdI8Ios0z/hm+RQ=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.9.2"
      "sha256-I2DTulIs3U41RyG88d1vlEX6J88CVNdpw2cDgdPftuE=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.9.2"
      "sha256-DOB30U5MlCeOcxzGAn5Gop1rZlKudwAU2yx4j/hvIWc=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.9.2"
      "sha256-8nuZ3RMTC4M7SQPoM+R6Sm5mq1dwttCpvUYW9bdMWKk=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.9.2"
      "sha256-KqtUipBF6NfZpAgn2yzaPIQN1rITPlpLm571V+4XBco=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.9.2"
      "sha256-0hdNmUelw3QBjb3MNVroqwaipa7JH3EIkRK6L+TBX78=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.9.2"
      "sha256-WPn+pMmCt3ngkVW1p3tgcaya7OG0etuSDNCaJ/gfgSs=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.9.2"
      "sha256-NAnswlIRm+gNOYdN1IB9uKzmU34p0YotYnhB0aVSzqo=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.9.2"
      "sha256-9MJCieeVnxXCVWWWbXBYHkU462m8at79bTLfguKjI1s=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.9.2"
      "sha256-pJvaAYElhSN83pk/f0rGLqJjM6YJ83ry0mZOIu8SNeU=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.9.2"
      "sha256-OCQOiu+ipMnnaAYxS84FwVGibiCz2Zq4/oT0rY+8qkQ=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.9.2"
      "sha256-VG6KhGtmVz8Ot5KMIZN+CdbCl4kj45W9JjfAqzoxQOQ=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.9.2"
      "sha256-3AzQoojKI/LxBDMI58hPyD0iJxNfESPrkUFr786yUvk=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.9.2"
      "sha256-hFgM2a527XXVNBxywD7g2Wgzzg69F7VmyMhPOWP6ML0=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.9.2"
      "sha256-3zHeHYIz5Z4rYp1qibRiuAZRjq2PcB5mtZllqcAEHGE=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.9.2"
      "sha256-RPFMdrmT0wrzouXQAOknrbAX90nIqq4lYNWHKSFIYJI=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.9.2"
      "sha256-0Qpe4UdTiirB1qG3UE7Ia1392u7GPo/o9oHtmj4b1oA=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.9.2"
      "sha256-1vnVitAmlS4mZNcjs5A3t8klAtjYRtnVVV3+C9QvXRc=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.9.2"
      "sha256-I+my67Vk5YGCK9jyXrPsVDZdUpb0hIJYng/qh4iWAto=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.9.2"
      "sha256-rRstFOMyknCM5i4yZI/nPP6TdI6qSCNRR1h55wj++Nc=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.9.2"
      "sha256-EQgFCpnDzD8wljFo2R2gYA25fAoez/YLqWc44/iZPMI=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.9.2"
      "sha256-fpOMrumNYGLzlwaWScJ3atfOIIVdp8YIA+5ZX8c2k2o=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.9.2"
      "sha256-XqoKF4jpsnJ42WLPueWCezaWGuCZgHqjIoSi8aGWu68=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.9.2"
      "sha256-QAhRXslvJJZuxi14xTmInqZczktwUhiz8uWJllGDtso=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.9.2"
      "sha256-GNnd9lRQfa60gBrxbf98Dmoai3alak+BidHiuIFATCY=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.9.2"
      "sha256-bN4HEGv6eDF19A5cEZ5thOSRX6MIZTiPMXE8Cl/H5yY=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.9.2"
      "sha256-36F22GuIn5h6n3HRFtDtBQH/HpJtbUdjMMqmrn7mAy8=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.9.2"
      "sha256-7CH1FFKImkHTr1LWrsDeGpyMYi+jK2PeOCBQ0B+989c=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.9.2"
      "sha256-2m99s+6Jw+pa2ESpHVskVqrbef4HCz8lEbjry+1IPhI=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.9.2"
      "sha256-eF4c2Euy16TsPBWmN2uXI8rwqmom9QMmkninUEzEElg=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.9.2"
      "sha256-UNmuxQZuLwvYxwu6PfCEJnyUAR+hYrEUQMtWH+CKf7s=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.9.2"
      "sha256-6RDjt10J8VGt10a1OwVr4Ad7MTGA53LttGlegF1htU4=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.9.2"
      "sha256-AFXeOb3+qZ5u8xY8m5HvVx7YX+t9WjmoVgNCO7Z78EA=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.9.2"
      "sha256-BhlTasB/8WCPlvT34ZFt3bESj3x3D8+HJ3ClEeED78o=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.9.2"
      "sha256-RSQCRuibqPtHc6oWb9PBLQNA7EX7npMXc3wC9Sjy/Co=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.9.2"
      "sha256-FEcJK0XLz+4l9w8bibA/07uiROd6YJTqSVSqGI0zDf0=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.9.2"
      "sha256-4iazXLegsT66ngOm++0/Go5v+ea0aA8EOBntLXIrNDg=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.9.2"
      "sha256-yxn/b5PS1PCWkRc9uzzmyhihSHJf9zmEJ3aJ3JW1LxM=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.9.2"
      "sha256-9Ri/e9Cr6jd2skRfgMDWbILQC9ByyS7EoJMRKt68NBk=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.9.2"
      "sha256-MvZTZRZ6OQCR0hUp+SO1DW9da6bNU/zS0ZRhDQPFAvQ=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.9.2"
      "sha256-q57KMOKkvmgCCAbThlcB0kF3XLWJ4/u/9sCZtWV7MWk=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.9.2"
      "sha256-/nIblU81ZpFgWrrRHfsjALvO/gKH+D9aD9zpq91eru0=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.9.2"
      "sha256-y+RREyIw/zyoJTW0eS4pleJWeCM3TDiKfYKShhgQzNg=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.9.2"
      "sha256-mM5cKfkx5uNtLWr6LOgbzmZ/qasU/INHhzGHi+1lNhs=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.9.2"
      "sha256-ehhqSgkxEc2kQ4vyH8y3ongGFytfVhjWJ8q3spuRzUA=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.9.2"
      "sha256-8M0WKXpkwC9Ltd8g+SSCqUHBvsugl4H59iwmAZSYd2w=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.9.2"
      "sha256-2enNMPhL2+811xy88fx/jKZ8NRcyYsQwJNj7uQcg4Rc=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.9.2"
      "sha256-Cmj6K9IRIftgGIQVDnNIDam33j4/6RmaR+/LC2SWeLM=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.9.2"
      "sha256-vfIj4h8kffcIZhT0tnFNv1a+HqU7cQ4Nc9T7kYYfKM8=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.9.2"
      "sha256-DOP+YLupQ2pHLTG6X024EmfMAFvJ8DGzPILXPo4hl0E=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.9.2"
      "sha256-6ghhaCipPrHrWeeSNHB9ayfaF6DNpa3fB4VcZ0Aolcg=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.9.2"
      "sha256-FJ+FfkZF49f8HdLaSRE8uUy5TpwIF1eUWvmcei3i3x0=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.9.2"
      "sha256-io7Un7WAlSjGuvTL8sTtx4vpRe/UcbD0bfq61eeETZ8=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.9.2"
      "sha256-w2akeYKPSJmclZkle7UV9sqt7xJOwjdW5dqpxh1+akk=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.9.2"
      "sha256-OxQKZbGjs67jqcRwzVmW382+VoRcOURRMlGsUCHoOM4=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.9.2"
      "sha256-3ohWpB+Xu7BRMZOrm1m0SFQ/imoN9uj0Qt41aEPLPTs=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.9.2"
      "sha256-N4F6+z9sodj3uWRzJzv7sgwjGF110VLocHw5fhXborM=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.9.2"
      "sha256-S26LJ3Y7kYgliw+zvUxn+NZziyQtQOAi2G/ticcm57A=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.9.2"
      "sha256-njtK69ZUaO1/RnPIeAWr7cBOlP4j/2XvS9K7u2lMbdM=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.9.2"
      "sha256-XoSCh39KzqCq7NTULVw+l38FOdGKBfFbvn1stRejsZ0=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.9.2"
      "sha256-LdHaFMrCBzwgtDSGeqrZQM2739/bYZ7B1uhXlQzIQak=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.9.2"
      "sha256-OsHkGDNoJkIfy9Hl5wJ9Fx/wc5YN5fUtmmlm7TGlMw4=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.9.2"
      "sha256-qFv0wDpowB/Fv6zgj4v16Q2RsIMI0cvAVf9gqN7ZMMA=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.9.2"
      "sha256-stiFRstnH2zyNqi6zwnB5X4Jx9k23QygIUMfTQi1Pe8=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.9.2"
      "sha256-AlEboBzWoHeXaT3njIVsi+OOnvpcAhK2zLG5tl5RuiA=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.9.2"
      "sha256-4jTRZivVfuf81e2zMdhTcyyzHvOiZXYZGpRh5Kw4fb0=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.9.2"
      "sha256-lqHdyFtlgN0kSzA0e8ORMXFUpDaMwhaF7vgYsiPukbY=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.9.2"
      "sha256-oti/KxENj8uH7mjhI4Lx209tD+Ge2BaKQ2g0kLMGzZk=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.9.2"
      "sha256-GWLW19D0uyn53RsFimOg86G4P11TShnznY+z4e+vVeo=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.9.2"
      "sha256-bX8tCfRfEhQPOcgs+JBZQjVqWWNClOOiFSOlj/uph70=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.9.2"
      "sha256-uocCSZ5BQmuG4hJ0Im8Xx5M0rlPpkYUC3esq69QeK9g=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.9.2"
      "sha256-BUjK0VM95zjMRsEpSJ0d076N7hcWkRqU2y7vrK241VU=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.9.2"
      "sha256-vzffi7HfNn3lZxpcIhcibiLpUugvcmTOu+eULfzM7XQ=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.9.2"
      "sha256-fA+3KgLj+MB4eoGlmB9HS9BOKI/CA5DEeCwGzHeapnI=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.9.2"
      "sha256-rcZPcLqJCiWZjx3743Q/Bor9qOgcqGvQ7G8RvyjkNVE=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.9.2"
      "sha256-+60l3/4HgvGq2XtiYVtTGrwJMKYq9QppZVfwa2sSWOM=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.9.2"
      "sha256-QoXp6ApWkwHeKiXhXKHes2riOmb39b5RNwdcgyB8yk4=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.9.2"
      "sha256-Lzuuk4/81ON1Jz/iVyfvQjaZl1ENqUY2HCIsrpP0fdw=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.9.2"
      "sha256-UpeG9cZximkH/Ugdj8vSNrkqGusssYlGA3b/KS3hEk8=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.9.2"
      "sha256-iMEoJlbv8GOEMViJKHfACVgFgX/kYi26Op+DOm7xtYU=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.9.2"
      "sha256-7JovaFOw3NG1vyB8pwn8UiWt8DVD2vOMU+cyY1zCWa0=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.9.2"
      "sha256-eumosBUDopuFkSLwywuGGD68h5+cPmoVNs9d1H8aqkQ=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.9.2"
      "sha256-8jg3bPKzGW8RCkBSm1oSnsjg/QHW7I8sQV+YF53dPwM=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.9.2"
      "sha256-2sEjMBciKhU429V3kBY1WlvCFczsUcBkVZQBH210iEo=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.9.2"
      "sha256-TKpDxDnEYjsChuEhWU2TuRAZo2xYJGLqXL4lkov/EJ0=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.9.2"
      "sha256-XmMPsqCla1qplSdbYV6fyi7GQgESr7kcwGoMlzcqh3k=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.9.2"
      "sha256-jSNlgu3w1GKZOW3kj+MNtyuJlxoOuRUBQfugv/UZSWw=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.9.2"
      "sha256-IIKsYhJovD2I/S86ABPXavHiwSLw+FLaKJ3uYHWFuQs=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.9.2"
      "sha256-EMYaX3s0eaQSdPdHPnxUeoTbgLG8ySBbR//hc6n3hBE=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.9.2"
      "sha256-CQzsfHF+scmNhNWhJ4CGWuD3Zu3W3WoH+tADh11VSJE=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.9.2"
      "sha256-SHh7ACl4EON7UdbnhihyR8FR1//WjStV/E7FaVEl0TM=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.9.2"
      "sha256-2FvSWGqjmDMNmB/5rUyBffbiv1q6f+/SHHxO3GTAqg8=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.9.2"
      "sha256-i+bv86ZvLXqPXGHlYfDzq7kgPIbre0dsMIdmNads78I=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.9.2"
      "sha256-BPszTqH+qcOlbzrX3F3r2S/e3XKODbSpJXbVcfDGXqQ=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.9.2"
      "sha256-wtInCko6bKPB5uckfKFxjd///LshrvqUKrp5EzunwT0=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.9.2"
      "sha256-izP0VJjTDQWi/7eKcw4bTSXeTmOQOLnz7KomU575ZK0=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.9.2"
      "sha256-s+fvYkr7blHqd6wp3nG25rUPO3lFepe7gVWPPNGP3WM=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.9.2"
      "sha256-WwryeZtut1wTLyWbYBUxsc5G2dDyYysvPkhkBgFQEec=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.9.2"
      "sha256-o5DyAC4khll/SSptK0B/bEJ0WQTDMOC4zv8fRa5dtZM=";

  types-aiobotocore-iot-roborunner =
    buildTypesAiobotocorePackage "iot-roborunner" "2.12.2"
      "sha256-O/nGvYfUibI4EvHgONtkYHFv/dZSpHCehXjietPiMJo=";

  types-aiobotocore-iot1click-devices =
    buildTypesAiobotocorePackage "iot1click-devices" "2.16.1"
      "sha256-gnQZJMw+Q37B3qu1eYDNxYdEyxNRRZlqAsa4OgZbb40=";

  types-aiobotocore-iot1click-projects =
    buildTypesAiobotocorePackage "iot1click-projects" "2.16.1"
      "sha256-qK5dPunPAbC7xIramYINSda50Zum6yQ4n2BfuOgLC58=";

  types-aiobotocore-iotanalytics =
    buildTypesAiobotocorePackage "iotanalytics" "3.1.1"
      "sha256-Yf1vvasgtUxFiEfSrlPq0Q2yhbAOGyRATzid+qYjlj8=";

  types-aiobotocore-iotdeviceadvisor =
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.9.2"
      "sha256-+Rgy9Y+8JUtSi7b08zCIvOJYY33Wxs9s42o8LjgvkRQ=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.7.0"
      "sha256-isYjEnViFGsgtRDb3Y2i9vTCjqDcB88rM8JmxhpxIII=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.7.0"
      "sha256-FZZowHBNWFF3pWDNZIG12vR9NbWfWNWxt+IJvZYlp3Y=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.9.2"
      "sha256-7fuLIw9YdNl0msH/I91Cs+Bz+ejZeIL9jwlDLf+AkTk=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.9.2"
      "sha256-hud2e25tjxwVw6xMSo9Xcj4I7Z5k4cdY8j75qJ9xD34=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.9.2"
      "sha256-ikTO4pK+qyIVfppJTcAWBAlxVxmq/Lf8jOOKz+/htgs=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.9.2"
      "sha256-VIw+65jYcGXDBIra0yMv6I/3b8OdzdCF1Eidq2OEsro=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.9.2"
      "sha256-Zm6vIXqYhJfmWUdkIOkWzPLGmF/GvWcxfmn/BGPk+XA=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.9.2"
      "sha256-st8JvcDVWsTXTMn2vh4Q1kVT6FkojgTwal/In2z1Vck=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.9.2"
      "sha256-PwcTGz7naVYXNq4KVkpwBbptsuM066kL0Rpul+Mf0P0=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.9.2"
      "sha256-dPld2357AUwkPb/izf7FFR3IzLRFmm/9Spag20RaM6M=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.9.2"
      "sha256-mgiF+nEAR58ERFwBLAXI75+znAbPB8dJ/WC5FhSTxu4=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.9.2"
      "sha256-jKG1Q1UKITdWMa4FB8sQ1KLxHtA4dniIUjOe9J2oVhA=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.9.2"
      "sha256-JSwGcHURsP18QtbU3jKN8lsDDlKkhi9JY9VOlDU9kgg=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.9.2"
      "sha256-9PyH2YCiOW0A75h89MjNKsH9LWhcKUKpc6S+0Xl+ao0=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.9.2"
      "sha256-AecLTSac9+zhY9tl9901vC4N41iylYfDhA/OiFOnMGY=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.9.2"
      "sha256-pFW+W2c11vOG0691BPltjDHN2s9+ccRiDmMZSA5pDu4=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.9.2"
      "sha256-qtycBN1BtHFEKHrmQOQ149oBes0xU0ESIElnzfKGZqo=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.9.2"
      "sha256-R3JAkkgADMOTVakABn6Ibxkm+aEQTuMGZzWaf918lyE=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.9.2"
      "sha256-30a7W2vLqj5OWaTml6cKU7lEiEmv3BooHrdo5QQ8kPM=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.9.2"
      "sha256-8XP997uZ1adXPSqKl04N11vDHqVhFUs41GWoUrQ7sIo=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.9.2"
      "sha256-pcP2WPBgkpiBWnaItcQ72vvsojjpH6lCHFNMq2sEYpY=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.9.2"
      "sha256-s91TL6gbhdk03+5nkpiDSMy49Vdw8+zrPRHy/JSjEWI=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.9.2"
      "sha256-qUgDnzXW1akHm5jpkLA+eic8rgwRRatFwoxzX9pQDsI=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.9.2"
      "sha256-4r6I8wcj/PkyY3FF8Q7a3jdnRXHogpP2951qkd5/Mfo=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.9.2"
      "sha256-VVxC8V4V/lfqEiq5Dabsac6KGxG4Udg7Pc/hVIPZqSY=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.9.2"
      "sha256-e6q54iVhbsPEZBRe9eiv8CfYkIBHgt4wowRFE9hvk5o=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.9.2"
      "sha256-2IU9iNDxW+GeidEvKnqoCdJH7YlCJ3wVTCJYZrdu2+c=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.9.2"
      "sha256-0fbcaxZCMn0LUSUK6CFl/l0nQ6BoUYxaprNoAIiZqHQ=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.9.2"
      "sha256-i0eiJ5xg0E4if2Dp5PS9wY7MSRqdx2ah7o26ogwedIg=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.9.2"
      "sha256-iv/NTUDSXR3LxTQM1ivoEl+KpPeo3drIBZcPNtPxtb0=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.9.2"
      "sha256-Psld+xWAw+JXKG0qd4gYT13CIGb99TUjQ5OTF1Oln5s=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.9.2"
      "sha256-8xShk7vWR3RcNXYxJAIViAL/phBuG5wT9bkJVPkxEfk=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.9.2"
      "sha256-ETUB4c4wBvjfqpsNlglAg04X5pDQ4HfyYC7eV/mDzPU=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.9.2"
      "sha256-j8tvdovvvezhySFm4aVacc0Sv6sjuVj/+iBflDrIbRs=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.9.2"
      "sha256-LtUziTG2MiNtdaqDJgVmVp79KEwnUJeII0YmXQ9fJww=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.9.2"
      "sha256-4vdMtAk4tHDELmCP0KTKHZVqkQps1Sv2xu67w/gUVcs=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.9.2"
      "sha256-tOD71PmuCNoiZdPk44Zm9RFffVz+CTO0VWIF8JMC2VY=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.9.2"
      "sha256-yJHNMr+CLcK4BDCweQEBfhHd0r2B27umWdBm85iJqxM=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.9.2"
      "sha256-1eeE50/kq5H2bSVPHyyTzZct5RTyUiJa4pbvb0VYlzE=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.9.2"
      "sha256-B56dc6ihEfEotKOaDtpIqduJb9JIKH+HWvmJBNPbPRc=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.9.2"
      "sha256-zBomrsobM1TXTXdhkIM6svdAbx1IvRYcrIJX3Q6hwwo=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.9.2"
      "sha256-ZM9+WsuPEPnZfgeiRDojoKzNJ22z7voRXxeZvV1GgNc=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.9.2"
      "sha256-oYSpU35dgUuVI3a0S4bPWXefRIihuk5EW234SMVf/Jg=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.9.2"
      "sha256-7h+LCjZTtFD+/6QNgQGahKEeYqptniKmhOcskmOA7dk=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.9.2"
      "sha256-eoEnReMvdbKejP2a0fODfqE1WFlS6nDeOA4VwWNMXMk=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.9.2"
      "sha256-4hD7jodwRPl57PyD+a7QjeucHsqHP5fMzuQpMRqidzg=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.9.2"
      "sha256-OgAUXB/HS7UrTvCEX24ix3zvXlDTzyX9LYKSbluOxEU=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.9.2"
      "sha256-v5U0gRgBDw4z6CYd8o8FPli612sSUyBtZWTWHMuDmBY=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.9.2"
      "sha256-WAZw07WHI6yuKtWUNI5VWF/r2nFa+Qrl8HQRyet2PhM=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.9.2"
      "sha256-kL5P5fze6R8O7hj6wxX/azztaPaAAAQeuaKr4/B72PA=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.9.2"
      "sha256-FqdRjkQyoUhOwn2E1Bx7X05GxmnkEshA1YWr3wjP0Kg=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.9.2"
      "sha256-R+g2Ysp9XLUZfbJTTBGpNGWoUIfAiz/fj37O6gFPh4U=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.9.2"
      "sha256-zs+7jEEeftaCFUzywL9+yk7PCWofXzMFHrqyDnrs6LM=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.9.2"
      "sha256-yScH50sxZTLDGlN7u0OGowCngvXl4cpo2leEv9CSwTk=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.9.2"
      "sha256-YCbmZoklC5/6U1nBo9OLKY1LmemcD9GI+CDuQSG+/+M=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.9.2"
      "sha256-ylhvbskCoJpw5hUM+Xqi/OgDbbzyFKelzb56sVEzNE8=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.9.2"
      "sha256-tq/q+4y8jyQq8zT2xS/TZ9Az4384mPQvmu7C7NWTvF0=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.9.2"
      "sha256-8Ya8ZxWafehx22HgSoc960unelBBP6O81Y6Ot/+t8HI=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.9.2"
      "sha256-gHJml2enWm2hzvgyo7ZYN4a+a6G6M5OQoMvjbxEt2hQ=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.9.2"
      "sha256-5jiSpfuP2E6wvK2447NGNDO5ytlVwTh/34OknO96veI=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.9.2"
      "sha256-EGXdLmY1ox0ZkMlcJ3QE95z1Bq/RCGpYC/7LWDDKuCA=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.9.2"
      "sha256-eeu5Ef5y+mi+NDTPOUWu9KoSx2uBi7fCkncK41pFiw4=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.9.2"
      "sha256-Yi3kwCvNGzETr/dLJ4uLftFxsNF1pjotgVDPWoVuhmM=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.9.2"
      "sha256-VKYy7E/657bbNJ1qvz4aD03Q9Zd/9ZBDLIzwlzmNoCM=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.9.2"
      "sha256-jmvlji4EnkNASUB3NYOXeH2F9hhw6ZizPjW5vRrId3w=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.9.2"
      "sha256-c03avEBmS5OA/Pln8sCffJZdT5ltRS1beG4OYQuH65A=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.9.2"
      "sha256-OTS9rSzPRWODPcyjGUIOg3mLlFAOieA+slUrobSzvMo=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.9.2"
      "sha256-G7njQypX+FfHvYh0ICy2siojmyGaZzvwAvYvNAeMAEM=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.9.2"
      "sha256-VyHygvHl/YdjRCdRuLvv7tXUYxvNqn1LM2tuwxRFw5I=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.9.2"
      "sha256-HSnGt9j7VAr3wsmyTekROQOk06rgbu9xoSeNhek5IH4=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.9.2"
      "sha256-jy/AMRym/wm9fL6sqPrCTKlQJxZNLuFQyXvAOF4p3iE=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.9.2"
      "sha256-fKDheVQcnZTfEimsmVhE8v8M85yr/MI2ONVMmfSStZA=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.9.2"
      "sha256-FUDlvXj04Tr0L3eSDcbg63+/2POVzDooLwkTILxSzVA=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.9.2"
      "sha256-XAfSTzfryqEk8K8lIv41noOKdJypMbEm419HRFHMeHA=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.9.2"
      "sha256-mK3zG4EXWk5j1WJQk5sa57Od8yNZ3k8U9TeY/CEY0UI=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.9.2"
      "sha256-aBRfX6SyEtRZpX60/jWF8soIFhXI3Qxm0W4BP6w8lYs=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.9.2"
      "sha256-CWtwnObyYGi2dcqTSHfWxN+3+Ugk0ORllw3HjvNx8aE=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.9.2"
      "sha256-Z6DzgaYx78ZgLZbd8X1rQPuEr2i1JODoTijVhmAtFJA=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.7.0"
      "sha256-yn1EAIvzNfFR1a3r8y9Ri5nOdprgEAYBuXw2Wt1hYIs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.9.2"
      "sha256-g2rUIawWZS1EHEfzq/3wPlfTYHhRSz2v62SM55zIj0Y=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.9.2"
      "sha256-oJjo4VCc8YS4a4jka/xQkajJ/sBR6FiRGliab0q+aFI=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.9.2"
      "sha256-qZCM2wG8gFxJdKsBeJZciPTKy0eId/MkON6LIV5LHiw=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.9.2"
      "sha256-jhDzS0V6i83Amsg0k2qElp3Dj/8QxEokrxgR2uzN6Zc=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.9.2"
      "sha256-melw2D8AAbBHTdMlJyXcLLcqX/3Ff8zh6dhNoUyltqY=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.9.2"
      "sha256-Ukc6S2+qkS6OT/3q7/oTFJGnbgqtX6nDhGiX5qaZG+s=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.9.2"
      "sha256-svX0ZH5o2cdBEwQqO6f8bcvbmHALZGqpwZ21jrt7Yks=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.9.2"
      "sha256-cHhaWs5j7WTj7lAcNdtHfYiVOCya6P0AASJTfut+LMc=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.9.2"
      "sha256-q8eCc9fYYsqgx2Jd0n8WUW/KWFh2BL6XbQcy7IjyQWo=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.9.2"
      "sha256-CNurHBVienKeMkP0HTPT3DGTRaU8WI4axa2QXSgQbIw=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.9.2"
      "sha256-5B9Hfsc+wSZQzre/9NkHZjIfF/zbzBVct8oLV3r7y2I=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.9.2"
      "sha256-nj6PYTK4sZ6aRY+hObm/nBe22LCgUlqBw7AR/jFCFd0=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.9.2"
      "sha256-f/pDSb8ivcykaY5eFBdsH8oQA6haPm190s9ZrwfIubU=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.9.2"
      "sha256-woQVVSDFi9I26GoWBqcOIyQvrWib4GgZwKEMeHIRddQ=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.9.2"
      "sha256-JXhsUJTpkv4utAnkCRuykRXNSPkUcta32EXhi+fw2C4=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.9.2"
      "sha256-ikSyNHJYeoVy3OSBiklG3RbDMyXUmpY82wRnvmF5Nco=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.9.2"
      "sha256-e971qPwgn6Z7fd1DQe2i0yuaDxcWMbZ0UTVqSs9a2fs=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.9.2"
      "sha256-KGESg22BKzNQOXOYOWNu0rHk1o4H3zYU7PqJazr4Cug=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.9.2"
      "sha256-zjp5NbJ145D10aCwj0+NggfbUJGggHLeBV9ltG78QXc=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.9.2"
      "sha256-Zce7kbpa36H1D3HLMd/w9txocFa1R+iyO94lJemSTH0=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.9.2"
      "sha256-ipG1XV66n+cwMKQWUeVN8Ne1JjLkW6/uk9nPFyT9Y0I=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.9.2"
      "sha256-PU++XhxbIGYpsdXUryP18SmWFRZqXZKsy0jSPDtajXQ=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.9.2"
      "sha256-dS6cDbmkcOciBof7csDkI2WbCcpISvQR/O3rrTq/7r0=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.9.2"
      "sha256-mp3aAjHWIgtVU/kWOlwfDGhA+5/R6WhSnCPYegh/G1Y=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.9.2"
      "sha256-aRfl6MTreJZzh/jEHIDyKbs65Q5zde/JfpoeKnVwu68=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.9.2"
      "sha256-EwXDOuxGX6fFJ1Zc4FZxooTWXV2hjFyjBFUFAUVUT3E=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.9.2"
      "sha256-PaJy6nu/4zPGO6FX2S7/o5pJB3AndDeFd7w1Ox5UhNI=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.9.2"
      "sha256-NzTrvhutmGgkObE8aGFAIOsnSVqi/n69r5yUmIhJ22o=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.9.2"
      "sha256-T0GonuxxXxrBgdunUclySB/fi+M8FPFcixtf1a6gjws=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.9.2"
      "sha256-w8/R7MkJaxKh4to/h2xU+4pkiYE+qHOlFMi+IKsre2Q=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.9.2"
      "sha256-e+nc5GgvB8sU7wXCJseGcJ5lHI/2zMPI9Y0DTh1Tb8o=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.9.2"
      "sha256-as3qgfYRCCPrwbJkFPC3NPD2trXCoi2p4MqhJyb4k4Y=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.9.2"
      "sha256-IG3KNdMN24OvHramzQYmDpg8Z+ISuEcCeC36b/ElaMg=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.9.2"
      "sha256-oNR7S5YW5+eQ+FSNaCasfd0ruro05ggeHq6cWX2j8nY=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.9.2"
      "sha256-Xpy+QBgO5WZFcZ38abZHQloOSkKJ6fZXT0aavnVtVcc=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.9.2"
      "sha256-ajsDDoPukUrzntYKvfDMku3qJobFTzM6uDXmh3eMyGg=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.9.2"
      "sha256-KaKvEeYD4EPYJL3vN3SPZzOJmYO+irI+qriwZRW6EoE=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.9.2"
      "sha256-svlQLqsprfIedfEa5oYk8TAWSJFaBaAibr+K+8q1OmM=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.9.2"
      "sha256-EHCTJdKsx5Ktn6EtD/+TED0GhaNuTgjB6CUrqAyoZXA=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.9.2"
      "sha256-jhu/+tnEZ1REf1OzmtKIwa/s7Cd7Efs7hqNWBfBhM0A=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.9.2"
      "sha256-l9eBNDQgiAVXB9C6vq9oC1jATKE1kAn+Fu2lSA/nfdA=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.9.2"
      "sha256-oYoR1nc3dgburDrDtQkZs+64iOBHKGmihKK0qSeDFcU=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.9.2"
      "sha256-F72rqsjv5vPHeT0sSIDJEStNZ1kYBeYVOZuMUJUeQFw=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.9.2"
      "sha256-3WxN7twlE+qhdQeHGFwQoXNwtfwm+0i9ZdZDJRMd1pk=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.9.2"
      "sha256-Kyvvm2mmJjnKUe4f1BGFJ+5n3SIo9MgvszZTQo9rlZU=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.9.2"
      "sha256-/DxTVYPkMWyWWbKrO0hXwxLqDmCc4obUqRmKmcet7cs=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.9.2"
      "sha256-avSj0K4qUicDgIUETPzw696qSn4toV+vad6ETeAmV+Q=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.9.2"
      "sha256-reIpM83NfwnQNRkEHDnjv2otrK1Xo5u7nEm2nM2xgbY=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.9.2"
      "sha256-kqv2bzotheWIS+IRyAzqEgtsf8wwnF6WJruMPsAPRKU=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.9.2"
      "sha256-ek8Db7ENnXxodU+5t/eBUf5ryGG/lsLGPOZmP2EEYns=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.9.2"
      "sha256-pwzajzcdQgsa/oqpSbowrBlOi8dCaQN5hPftbSCQXmo=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.9.2"
      "sha256-c5S+29RavNYiTmvo7jNIYfTf87Rg80p9PE6+Bm9KLp0=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.9.2"
      "sha256-Mi78E5vWTLQ7sfG8vxDEys4GFDpTehVDoXn2bUNpFEI=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.9.2"
      "sha256-m4hcVrahVnKR4zA19eVbC7pamRjLFM0rK/Sl40Aqid8=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.9.2"
      "sha256-pFMApPYHYqru3FuwlPdxBrhUX6dAKLbdvoCdwbPomeY=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.9.2"
      "sha256-E7jq8IMYL51HrRLEuUN8EzhK1RPcqK65dmVV3Or41/4=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.9.2"
      "sha256-Ioe0I0Ny+wcFZr1atK+vscQi/Qb/Wz4QYLyRdpI19h0=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.9.2"
      "sha256-gF5hyCKr/p3OYeqJrOohPCvmfY2GXCgfL7vh98V+jSE=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.9.2"
      "sha256-iVXYdfKsugROa/OnSk+UEX1Zsoe2oM8z08NVU1dTZt4=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.9.2"
      "sha256-754bwQvWUIlB6mpVuP3RyuVvgJteZD0JOSlwDMN2LQw=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.9.2"
      "sha256-D8+qHys27RM02SL9/GSJaRuiqPJUE+OB0YETbBoMsgc=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.9.2"
      "sha256-8TyUzLL9kxOxPKED/yJvEMGMOyS7nVTjAYyYbUnAGrM=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.9.2"
      "sha256-ReM34lgOmJHp9UfNtnWqaphgJ9zqflvWgPP8gtFCojc=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.9.2"
      "sha256-gxzzdRHEgWHjd24WsnZ8Uyr8fym/tQyoQIN7xsa1MPU=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.7.0"
      "sha256-tZQL781zQI+vVvO0S3cHzw5RGAHKXeNeJW7E8tzCHA4=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.9.2"
      "sha256-QBYa490MNeF7nPzMomeRTMbNmCVvVy4b7G/CCk/jk48=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.9.2"
      "sha256-dk6w1X8MoB1TkhD5w8PBIofh+GIV+5kIT6t9XzmJCa4=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.9.2"
      "sha256-iYjPBAtSFonn51UnST+SqIefsl8qsLXsjawgS3Dy7K4=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.9.2"
      "sha256-EXsiFhHvCINMAevyAPXxDziBK6Vj+Aj0WWKRqNMvvl0=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.9.2"
      "sha256-EBjcOUoVOeFUTjAfMGfI1rD38Qu50QY6cDlZpQ8F+nU=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.9.2"
      "sha256-R21/aPItQcfZJYRYeaqYMcWx/ESu1fGO5jkTKkCn6o8=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.9.2"
      "sha256-jVz9+vCKs+c7cwkeKetXolLMMFrEPu1afilbOJBNdj4=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.9.2"
      "sha256-3+XNqlCsUJS2p4hCcyU2+JkJdk/D4QkZhcVa+YrAO3k=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.9.2"
      "sha256-MJssQMCn6Zm1RRPBNNOq6bTIxRGkElSyeIf9CP/I3Mo=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.9.2"
      "sha256-qNP8KlqTwW01kSlFIlhylNcHNljLj8JhIlrdQi6y+6c=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.9.2"
      "sha256-JmP0Bhcg7RCkR1iBvxj4pJ+S2+B3Fawr+8GBXd7109I=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.9.2"
      "sha256-76cXxfHMSFdbavFEpiecyd8cpqv7cnkSyEnrkdezZsM=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.9.2"
      "sha256-MFaUwXmBP707C7S2IMsL6w7dTFK/Uau4jZSaUifQhQU=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.9.2"
      "sha256-NhH4mgooKD7qtSTyGZnNDUXkcHsfi8lL3iS/rw/s2M8=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.9.2"
      "sha256-1BzozKdCm76AKK0JxmG5VqEWaxF+ifREeQVIVl6K1hk=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.9.2"
      "sha256-4b0PO+RVtRbaZFZb658BtPqc8WsSnv3mjgyXvexlStk=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.9.2"
      "sha256-CQ2tChl5ZGtS71HznVqfvnXUz/WOOEr89VrUv9y7NyU=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.9.2"
      "sha256-WgddYxWk+8TXxhMKMaznK7ntLWBhdGmTtg59D2qqmeI=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.9.2"
      "sha256-hP/4gdrskEiLpj/Qa07OjydgOqCRYCb8tfEIPC6tI9w=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.9.2"
      "sha256-CELGz3o+7r/W6rP8we7qSWduAXVGBw4Ot9ZmN30e/HI=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.9.2"
      "sha256-iunYHG8mLwy2Jfeo8GJWBS6LWM815ZiAX5hB7s1x10o=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.9.2"
      "sha256-H1l4DMqga0HexIhQ1D7LvLx/cbKRxKjiNU1KHMB0NZg=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.9.2"
      "sha256-hgYkRUcoME1w225NFEcFUthivmMsnrbv1AUGX2FKKCs=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.9.2"
      "sha256-xet9cMK7Dgoo8IaJlltUOqMJb56MKUJ11rT3br4c1aw=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.9.2"
      "sha256-FS3C3QVYrT4jNe0hL6JMAHW3nGdqwyr/drzA28+BEHs=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.9.2"
      "sha256-LrREHkQUOa4QJyHkY4RSjMsTLQjEoN5dbQflUM+FaM0=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.9.2"
      "sha256-PeEY1wEfuvk29cb9qoU5S/ubD94WsvUf8EwSRftkxmU=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.9.2"
      "sha256-QawG1E93NG/iUtvzstl1mkbLWnsBDk3NnbfEMgMiGqI=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.9.2"
      "sha256-X3sfqsWTqCqRMwtOGwsMGewXiDVyMsfJ99vxawbQIFA=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.9.2"
      "sha256-ffZzqGFer1/j+qqX+0cfY33RmH8z0SLl8vdWkRel8dM=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.9.2"
      "sha256-+bGV2tFDgwzkL8wOr1fe518tjmNexy0IvpOSQPK4X+o=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.9.2"
      "sha256-9m3XydgAOBIk6i6rKiptOeXXFxnWnjJITqdvxPJwZpE=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.9.2"
      "sha256-2PGd2rOym/iP5sXw2DwEt7FRdKfuhx9zA+7nywA7KtM=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.9.2"
      "sha256-MKdQNxosQgQAUh62tSE8LNesZPviSuPdHfr0Scoi85E=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.9.2"
      "sha256-hYrs0oUArYOmHFR267EbBydp0yVgF34VddKKisF6o4k=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.9.2"
      "sha256-cIj7O3GUa5FkY6bXGcILVWjX2VMcf/Yr9crYj6ig4B8=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.9.2"
      "sha256-PBgMvJ3BdnMkDRsH8yz6XerODm36N5jL1U/54GjWa+0=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.9.2"
      "sha256-LktLOUEwAyZlZXISq83hHgpBOYFVCZ74AVGWgYap8Ck=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.9.2"
      "sha256-rnLiR4DPGrGIrgJ1EFSC969murLzCaLZaRQtmYPRcZk=";
}
