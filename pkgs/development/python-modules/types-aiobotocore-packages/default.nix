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
    buildTypesAiobotocorePackage "accessanalyzer" "3.1.1"
      "sha256-RqvxyNeYfZtFSXrOHJmbdLYXSXRg2sLDTvEXX7m1HxE=";

  types-aiobotocore-account =
    buildTypesAiobotocorePackage "account" "3.1.1"
      "sha256-hpjrOZPmdDebFhke8Hb4lub4pIlAqKVJXjyUHMWxFoI=";

  types-aiobotocore-acm =
    buildTypesAiobotocorePackage "acm" "3.1.1"
      "sha256-fiwbQUMWfZW1zcENYBrlRvFeJomakhXjMrySP/XnTqA=";

  types-aiobotocore-acm-pca =
    buildTypesAiobotocorePackage "acm-pca" "3.1.1"
      "sha256-RIOn/MY5SJJA2zchQlrtTnLthM396qimhQsHjrUOuWU=";

  types-aiobotocore-aiops =
    buildTypesAiobotocorePackage "aiops" "3.1.1"
      "sha256-8ukp5V/vwKO42pC8c0mlsY8KknPMgL+3wr5bJdWYnZk=";

  types-aiobotocore-alexaforbusiness =
    buildTypesAiobotocorePackage "alexaforbusiness" "2.13.0"
      "sha256-+w/InoQR2aZ5prieGhgEEp7auBiSSghG5zIIHY5Kyao=";

  types-aiobotocore-amp =
    buildTypesAiobotocorePackage "amp" "3.1.1"
      "sha256-7pkxm9Atyb9hJbvh77CYazI+VKnZEyj1Kk5WzRwQxs8=";

  types-aiobotocore-amplify =
    buildTypesAiobotocorePackage "amplify" "3.1.1"
      "sha256-CWsLx+R5FjnNSRAskfeEPYC2i3hO8vTrxedfKm+yVa4=";

  types-aiobotocore-amplifybackend =
    buildTypesAiobotocorePackage "amplifybackend" "3.1.1"
      "sha256-z4fosLbvTGITCt6I+EfoUbddbAH0R72JCbT3d19mh3U=";

  types-aiobotocore-amplifyuibuilder =
    buildTypesAiobotocorePackage "amplifyuibuilder" "3.1.1"
      "sha256-JnciPdyRpuEPEFpHbo07HfH4kJjPxJOb47DDeRoYbis=";

  types-aiobotocore-apigateway =
    buildTypesAiobotocorePackage "apigateway" "3.1.1"
      "sha256-L+FPKA/xS8JW8Gyh2xF8B+e3dIzBzblcz0azxaxeils=";

  types-aiobotocore-apigatewaymanagementapi =
    buildTypesAiobotocorePackage "apigatewaymanagementapi" "3.1.1"
      "sha256-PkrFDQPUHf6Z5Z8FwikujXNJiopEpCSm3e39L8ZTgt8=";

  types-aiobotocore-apigatewayv2 =
    buildTypesAiobotocorePackage "apigatewayv2" "3.1.1"
      "sha256-pYCAjpFWxUELP5xEmnKlFxIt2XCInAYS0MpRT0LHpNk=";

  types-aiobotocore-appconfig =
    buildTypesAiobotocorePackage "appconfig" "3.1.1"
      "sha256-YKTDSJbihDJJjbNZsJGmkJzUshLAHaKyCERaTUkl9KE=";

  types-aiobotocore-appconfigdata =
    buildTypesAiobotocorePackage "appconfigdata" "3.1.1"
      "sha256-ZRPeJKm8iBRsTG1C1ND8eDvVNKqYeTrBJVpl/4pSG/0=";

  types-aiobotocore-appfabric =
    buildTypesAiobotocorePackage "appfabric" "3.1.1"
      "sha256-27e25/UBj3YebwLjIVyIRKiADgOAi1i6FXx+BDCASUY=";

  types-aiobotocore-appflow =
    buildTypesAiobotocorePackage "appflow" "3.1.1"
      "sha256-BC80w924yKct8XN+y4sVnMzhzYunop0ycJ4FCBd3YcE=";

  types-aiobotocore-appintegrations =
    buildTypesAiobotocorePackage "appintegrations" "3.1.1"
      "sha256-brxHJmWcQBq12YjXgHyheRl25pE2ru7UNUiAKNPxDoU=";

  types-aiobotocore-application-autoscaling =
    buildTypesAiobotocorePackage "application-autoscaling" "3.1.1"
      "sha256-/iXR+FLQK0ERKoZiDFJGpttPKURMEIHRB5nmY9Cbe9c=";

  types-aiobotocore-application-insights =
    buildTypesAiobotocorePackage "application-insights" "3.1.1"
      "sha256-EGi08z/HnY5lNXdsvYg2fmnrsypYGcSpuO3pPz43+q0=";

  types-aiobotocore-applicationcostprofiler =
    buildTypesAiobotocorePackage "applicationcostprofiler" "3.1.1"
      "sha256-+v6ehROfGlqsPCclZKwe4ODl574r+NVv6MzGvQrxF1Y=";

  types-aiobotocore-appmesh =
    buildTypesAiobotocorePackage "appmesh" "3.1.1"
      "sha256-Wf+6wFF8rPb3Q6r/L+/kcJEZQdVIpuBx5gU6ix5ih5Y=";

  types-aiobotocore-apprunner =
    buildTypesAiobotocorePackage "apprunner" "3.1.1"
      "sha256-eDg3+J3hD/oJyBvZEhAU5kefSm4Za7DIraOgt5lU1do=";

  types-aiobotocore-appstream =
    buildTypesAiobotocorePackage "appstream" "3.1.1"
      "sha256-N6JcI3PtoDzleFZG0ObbWUbJNUvQ80U3w/JjNJOigsg=";

  types-aiobotocore-appsync =
    buildTypesAiobotocorePackage "appsync" "3.1.1"
      "sha256-vGFHM/EQEg9Mz8ARS9LZzDd6Cc66BMal1vT9CsPWN+c=";

  types-aiobotocore-arc-zonal-shift =
    buildTypesAiobotocorePackage "arc-zonal-shift" "3.1.1"
      "sha256-K9V6Q53AMdBBEARZqZfX4M488KM7Dv7GKhQHuNFhqlo=";

  types-aiobotocore-athena =
    buildTypesAiobotocorePackage "athena" "3.1.1"
      "sha256-jIuMq/70OcqwRnTwpDVvzwzwWMG10dlKtOGP32Agj2M=";

  types-aiobotocore-auditmanager =
    buildTypesAiobotocorePackage "auditmanager" "3.1.1"
      "sha256-5YiY8wd/detDqp8Z7tdj09rcpLbXF4NxwbIlLGJFZ1Y=";

  types-aiobotocore-autoscaling =
    buildTypesAiobotocorePackage "autoscaling" "3.1.1"
      "sha256-EzKNHZxD4EYREh9cnpvX+OYWBCtcRP0LgO34xpIutbA=";

  types-aiobotocore-autoscaling-plans =
    buildTypesAiobotocorePackage "autoscaling-plans" "3.1.1"
      "sha256-BieAUO3YZb+V/p3UmNJIhZfFHNSKebilymycp+yIW1c=";

  types-aiobotocore-backup =
    buildTypesAiobotocorePackage "backup" "3.1.1"
      "sha256-1tJJcCYre9c2sonM1e96yu0OdTn+l2FWZgFVf9kdbeU=";

  types-aiobotocore-backup-gateway =
    buildTypesAiobotocorePackage "backup-gateway" "3.1.1"
      "sha256-or/3kdieG8Zj79tTTZnw7MP6KWs143ILR9Rva/lIcw0=";

  types-aiobotocore-backupstorage =
    buildTypesAiobotocorePackage "backupstorage" "2.13.0"
      "sha256-YUKtBdBrdwL2yqDqOovvzDPbcv/sD8JLRnKz3Oh7iSU=";

  types-aiobotocore-batch =
    buildTypesAiobotocorePackage "batch" "3.1.1"
      "sha256-1M05bm3fbAkrGQ7MzI7m6VCAct9qA1kSRyFtpxDrS+U=";

  types-aiobotocore-billingconductor =
    buildTypesAiobotocorePackage "billingconductor" "3.1.1"
      "sha256-UAjXQHIJo5LiLrxoDQWgPpZJszmRFFd+o1uFn8Ds2jU=";

  types-aiobotocore-braket =
    buildTypesAiobotocorePackage "braket" "3.1.1"
      "sha256-1Gj61aOgoK6y3MLQc+H+/yxSB5xWkuJqY1xkRpN/aps=";

  types-aiobotocore-budgets =
    buildTypesAiobotocorePackage "budgets" "3.1.1"
      "sha256-TCzIIBCIDRCi0aA7Vz6CJgykxucEQpZKL85/pnAikpI=";

  types-aiobotocore-ce =
    buildTypesAiobotocorePackage "ce" "3.1.1"
      "sha256-qgo838uG/WRJBSHhMebwYzaosknBzjRwwVHXxibcqFE=";

  types-aiobotocore-chime =
    buildTypesAiobotocorePackage "chime" "3.1.1"
      "sha256-x1Yv7e1tUOpk0Ih+pN2qNQyRQSs5C9Tc8BMaWWHa9oM=";

  types-aiobotocore-chime-sdk-identity =
    buildTypesAiobotocorePackage "chime-sdk-identity" "3.1.1"
      "sha256-zpRklRxEiaO7WjgrWzrUtSY0guDyAbPyhZC1iafkU34=";

  types-aiobotocore-chime-sdk-media-pipelines =
    buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "3.1.1"
      "sha256-E+6Qy3Q+CuHKpVUHiyrt84rq6JgTYirc+Ir55x57iY4=";

  types-aiobotocore-chime-sdk-meetings =
    buildTypesAiobotocorePackage "chime-sdk-meetings" "3.1.1"
      "sha256-qdSmqlctq4Vpn0TZlo1Cqqv8Q/SpgKjs8Ar+BN5PmAc=";

  types-aiobotocore-chime-sdk-messaging =
    buildTypesAiobotocorePackage "chime-sdk-messaging" "3.1.1"
      "sha256-oe4E8diDZpY0pFX78V6qJG8ukOeMBlgMaTZQzj4/sYc=";

  types-aiobotocore-chime-sdk-voice =
    buildTypesAiobotocorePackage "chime-sdk-voice" "3.1.1"
      "sha256-j7s9epPxNdZh/uBqEMgX/S9D0PeelSuUe/oOWkMYebg=";

  types-aiobotocore-cleanrooms =
    buildTypesAiobotocorePackage "cleanrooms" "3.1.1"
      "sha256-nElh9uAw6rtIDx1S/8gRNmEfynCbbJp+KZPc4ZCwfu0=";

  types-aiobotocore-cloud9 =
    buildTypesAiobotocorePackage "cloud9" "3.1.1"
      "sha256-uIzJFa2XDwYp3SNrHkqa1Se7nw+7MkXoFataULJtOGc=";

  types-aiobotocore-cloudcontrol =
    buildTypesAiobotocorePackage "cloudcontrol" "3.1.1"
      "sha256-Em+QrqSEeZWY9FHMv9OxRnM6ZsF6J9G+aVYjSKgN6/k=";

  types-aiobotocore-clouddirectory =
    buildTypesAiobotocorePackage "clouddirectory" "3.1.1"
      "sha256-SnYs49214t9N3o2bwsEEcbE06iopc5ZCUwBeQupwYZU=";

  types-aiobotocore-cloudformation =
    buildTypesAiobotocorePackage "cloudformation" "3.1.1"
      "sha256-UuGjgAQPE5g6pGNm3yXF8Map22jex16SIp7hFvOLBCk=";

  types-aiobotocore-cloudfront =
    buildTypesAiobotocorePackage "cloudfront" "3.1.1"
      "sha256-7xxKqjNusACG4DFjV+DzragZBo4HxNHPIU2eZ+Rcxqs=";

  types-aiobotocore-cloudhsm =
    buildTypesAiobotocorePackage "cloudhsm" "3.1.1"
      "sha256-ckSAgYQtr8IlsIJ8BdLguqYx01DHHYhlwN6n53PJi8A=";

  types-aiobotocore-cloudhsmv2 =
    buildTypesAiobotocorePackage "cloudhsmv2" "3.1.1"
      "sha256-4UjFCxKlyw5XZryksWJvMZKG3w21wiZdizF5lu4zB4k=";

  types-aiobotocore-cloudsearch =
    buildTypesAiobotocorePackage "cloudsearch" "3.1.1"
      "sha256-xSgWv6ozbFtn3ucc0vDauGMgOFyIEe3Yusr4Bxnv6iQ=";

  types-aiobotocore-cloudsearchdomain =
    buildTypesAiobotocorePackage "cloudsearchdomain" "3.1.1"
      "sha256-Zvy0E+dtHbblSjKK+s1amd2gHlgtcD3tYzhYg1j0k5A=";

  types-aiobotocore-cloudtrail =
    buildTypesAiobotocorePackage "cloudtrail" "3.1.1"
      "sha256-Ba+HGg6KpmCaTr2Dg3t2qrxxat6wh/SLcsZA6eClawg=";

  types-aiobotocore-cloudtrail-data =
    buildTypesAiobotocorePackage "cloudtrail-data" "3.1.1"
      "sha256-nIoQZ2v471TukrJVyEgP84l09jIsm8A1EAstlmtBqWY=";

  types-aiobotocore-cloudwatch =
    buildTypesAiobotocorePackage "cloudwatch" "3.1.1"
      "sha256-jjG5vq1T2aCyQc09sPgEcC2rN91l1/GDYJG1f6iS044=";

  types-aiobotocore-codeartifact =
    buildTypesAiobotocorePackage "codeartifact" "3.1.1"
      "sha256-tnBrCNvS7r7gNH7RRB9/vZTAj4x9rK+qon0b8Oj9hWs=";

  types-aiobotocore-codebuild =
    buildTypesAiobotocorePackage "codebuild" "3.1.1"
      "sha256-vqS8ob5xr3qP7OcLTS7sHfoqxAW1g30FWfMHETKnwxg=";

  types-aiobotocore-codecatalyst =
    buildTypesAiobotocorePackage "codecatalyst" "3.1.1"
      "sha256-mZ4oJj5VjBJuB9+FiJNrWhZCXfeA26LmYVTZyAq84DU=";

  types-aiobotocore-codecommit =
    buildTypesAiobotocorePackage "codecommit" "3.1.1"
      "sha256-TOEnza/qiyVLATTlUf+WUh7zRtD+V+Vh3fkrb5WHHPs=";

  types-aiobotocore-codeconnections =
    buildTypesAiobotocorePackage "codeconnections" "3.1.1"
      "sha256-R/7XuO/KdWsUadXxH+fgobOAzmIQ+FTH330KQ8wUxww=";

  types-aiobotocore-codedeploy =
    buildTypesAiobotocorePackage "codedeploy" "3.1.1"
      "sha256-nBu9Uk1L4AhG3NcS128To+9pyHy4CBA9ODTa6XPPqWo=";

  types-aiobotocore-codeguru-reviewer =
    buildTypesAiobotocorePackage "codeguru-reviewer" "3.1.1"
      "sha256-mjlUraPceyD4VtBuTquWPxzeNw3HMpZdoAj+YwdsgNg=";

  types-aiobotocore-codeguru-security =
    buildTypesAiobotocorePackage "codeguru-security" "3.1.1"
      "sha256-Lg4vqrtDhTJj7GooerJBcsvwHGG4+US0lqb80EcKD1g=";

  types-aiobotocore-codeguruprofiler =
    buildTypesAiobotocorePackage "codeguruprofiler" "3.1.1"
      "sha256-0CsMOhN/oKoh3wIDAFb7pbAjAj+3V2pCqx21k8Bk878=";

  types-aiobotocore-codepipeline =
    buildTypesAiobotocorePackage "codepipeline" "3.1.1"
      "sha256-65ffxJgss339JKWbjlMDxQHCv+ReFBWzgVSPgDzMjYk=";

  types-aiobotocore-codestar =
    buildTypesAiobotocorePackage "codestar" "2.13.3"
      "sha256-Z1ewx2RjmxbOQZ7wXaN54PVOuRs6LP3rMpsrVTacwjo=";

  types-aiobotocore-codestar-connections =
    buildTypesAiobotocorePackage "codestar-connections" "3.1.1"
      "sha256-kFHaPMsXjX2LaSwuygVmyBdP3g2oMABH+Y2r5T/1jhk=";

  types-aiobotocore-codestar-notifications =
    buildTypesAiobotocorePackage "codestar-notifications" "3.1.1"
      "sha256-7J9aFKvZ7cGmLGCKVns+6DNY9Cp749R5kXcvbjUGruU=";

  types-aiobotocore-cognito-identity =
    buildTypesAiobotocorePackage "cognito-identity" "3.1.1"
      "sha256-7blur/20lTznEA9U0bZ3WShWsfFuZ+9A0mv7Gxnm690=";

  types-aiobotocore-cognito-idp =
    buildTypesAiobotocorePackage "cognito-idp" "3.1.1"
      "sha256-fnBsIrBFaFWKQct585WDV4f3EKZ7V2UKHYfg4lHLrQo=";

  types-aiobotocore-cognito-sync =
    buildTypesAiobotocorePackage "cognito-sync" "3.1.1"
      "sha256-0eUr55yuxy6khG/6I5Ty0GDEmNxncaVk0uocPVa3InU=";

  types-aiobotocore-comprehend =
    buildTypesAiobotocorePackage "comprehend" "3.1.1"
      "sha256-LIX04JMceLyH70VUWe+cVL+yqeRzPzvljpZSxGQwZD8=";

  types-aiobotocore-comprehendmedical =
    buildTypesAiobotocorePackage "comprehendmedical" "3.1.1"
      "sha256-sjXPsANgGkRMJqvjkFHaUYVFds++7YGTQV1VGrBBhtE=";

  types-aiobotocore-compute-optimizer =
    buildTypesAiobotocorePackage "compute-optimizer" "3.1.1"
      "sha256-w/d0rVpVdc4ouMckyJYkBb1OTvB+bHuGkVwAuZ1XQDo=";

  types-aiobotocore-config =
    buildTypesAiobotocorePackage "config" "3.1.1"
      "sha256-8ZyYp7V1v+PNV9pdi2aMYLL1KRXRx7vxaGuDHjf8ef0=";

  types-aiobotocore-connect =
    buildTypesAiobotocorePackage "connect" "3.1.1"
      "sha256-ctvHPJebwtSXfHTFGgiRNKdLrbJ/7N1tnZgD4f04c98=";

  types-aiobotocore-connect-contact-lens =
    buildTypesAiobotocorePackage "connect-contact-lens" "3.1.1"
      "sha256-x0ibjg6H3Biqy+oiDQI5l0IXblJpFsKPCD5oa+PqUt0=";

  types-aiobotocore-connectcampaigns =
    buildTypesAiobotocorePackage "connectcampaigns" "3.1.1"
      "sha256-cljoeOpPs0EzMev6fvEjTi1dZqiAbwhIyIDJ102+eKU=";

  types-aiobotocore-connectcases =
    buildTypesAiobotocorePackage "connectcases" "3.1.1"
      "sha256-p/IwTmfGpMcjwhdMvBi92gbSVa/ovt/gvXO0T88n7YE=";

  types-aiobotocore-connectparticipant =
    buildTypesAiobotocorePackage "connectparticipant" "3.1.1"
      "sha256-dYyX+8a/5FjT4gZlELaaRoPqvB8wQGCfvGaMjKhV2uI=";

  types-aiobotocore-controltower =
    buildTypesAiobotocorePackage "controltower" "3.1.1"
      "sha256-xQ91lpjqm3HDU/2F+Ftzbgzr38qf79nOM8w4pF3SgWE=";

  types-aiobotocore-cur =
    buildTypesAiobotocorePackage "cur" "3.1.1"
      "sha256-QS+iO2kPjft3mvIHWQ4jAFRz5aYwCmJTvCmydy6QL6U=";

  types-aiobotocore-customer-profiles =
    buildTypesAiobotocorePackage "customer-profiles" "3.1.1"
      "sha256-Zkz7GDatr85L54gcg0E8gNJE7BqQDRbwc3QY6YIFUHY=";

  types-aiobotocore-databrew =
    buildTypesAiobotocorePackage "databrew" "3.1.1"
      "sha256-6Fy3hOTNNhUYFfYYSY6lGI331KYyIaYsDXeP7+0U9Rk=";

  types-aiobotocore-dataexchange =
    buildTypesAiobotocorePackage "dataexchange" "3.1.1"
      "sha256-Gve/YrDZnwocilkFD8nxUc6jKAlxHiw4NvHXxLJ0LeY=";

  types-aiobotocore-datapipeline =
    buildTypesAiobotocorePackage "datapipeline" "3.1.1"
      "sha256-szI6s6RZvl4gFN8tZN4XycbE9xbJiNj1t63o3h548D0=";

  types-aiobotocore-datasync =
    buildTypesAiobotocorePackage "datasync" "3.1.1"
      "sha256-gIt9vawHcY2ey6wQIJ8xzYGL2I+UwK6T9iJhkBVoLyY=";

  types-aiobotocore-dax =
    buildTypesAiobotocorePackage "dax" "3.1.1"
      "sha256-KmZLCv196pr1vCQna4OVf1h0y9FdxhMtzd298hIOR1o=";

  types-aiobotocore-detective =
    buildTypesAiobotocorePackage "detective" "3.1.1"
      "sha256-BiQY4ettsk/xwjcDyQLyk69/HJyj+40ARYWrt9nDiMk=";

  types-aiobotocore-devicefarm =
    buildTypesAiobotocorePackage "devicefarm" "3.1.1"
      "sha256-CGvm5RZ1LHTh4O6Wxm7Yp78T74w4KWTtPBiAcTS4kKQ=";

  types-aiobotocore-devops-guru =
    buildTypesAiobotocorePackage "devops-guru" "3.1.1"
      "sha256-h5qvQaRshp1/nXIRAl0RSM6SZeJThlmEZusJBCMZNNU=";

  types-aiobotocore-directconnect =
    buildTypesAiobotocorePackage "directconnect" "3.1.1"
      "sha256-DF8G/ZQkR11+24bdSpYw5NQWRaL5soGuN4J+jAi8YUw=";

  types-aiobotocore-discovery =
    buildTypesAiobotocorePackage "discovery" "3.1.1"
      "sha256-xgswng92YmwzOKPR/flZvM4f5qtS9TOuM2qy3tzPOMo=";

  types-aiobotocore-dlm =
    buildTypesAiobotocorePackage "dlm" "3.1.1"
      "sha256-l0HyjJekikvNskRNfvkCAdfLsZNhCUBkk6OsGbZBeIA=";

  types-aiobotocore-dms =
    buildTypesAiobotocorePackage "dms" "3.1.1"
      "sha256-E/vG1SkS7AP8ZvdcQtQMNVy+utCf8H1/uNWzeX6DrUg=";

  types-aiobotocore-docdb =
    buildTypesAiobotocorePackage "docdb" "3.1.1"
      "sha256-sS7uOOlioCpORdutS9di5tWjyWKVxsmAsl41YKvqoHc=";

  types-aiobotocore-docdb-elastic =
    buildTypesAiobotocorePackage "docdb-elastic" "3.1.1"
      "sha256-cldJlQYNLpEwUX761g2c+zeuqLa4xArpHtNHUtScBeg=";

  types-aiobotocore-drs =
    buildTypesAiobotocorePackage "drs" "3.1.1"
      "sha256-kOCifJbAvdK2nX7nXwsILd0V5xTEmWe12Yni2/qlZOU=";

  types-aiobotocore-ds =
    buildTypesAiobotocorePackage "ds" "3.1.1"
      "sha256-ZOkuDRkJOnOArM1ZHI1cjrz6ZZuWCmEC9rVGUCdJwG4=";

  types-aiobotocore-dynamodb =
    buildTypesAiobotocorePackage "dynamodb" "3.1.1"
      "sha256-XUwVNWvPOMUe2tXxPhYzgoH3tlfpAtNpKraEZ7eWVls=";

  types-aiobotocore-dynamodbstreams =
    buildTypesAiobotocorePackage "dynamodbstreams" "3.1.1"
      "sha256-uSW9gS/EOsztp1p0slfe/42wCU+v2cjAqoIeoxBl31E=";

  types-aiobotocore-ebs =
    buildTypesAiobotocorePackage "ebs" "3.1.1"
      "sha256-tuFQ6kJTKVKsrtqb2htjdozq9j9fuRkXCCQZ32OY0fg=";

  types-aiobotocore-ec2 =
    buildTypesAiobotocorePackage "ec2" "3.1.1"
      "sha256-wbNNprZkFgMbb6xlSXWYjAHVXvL9uaT58hr65OrkUPc=";

  types-aiobotocore-ec2-instance-connect =
    buildTypesAiobotocorePackage "ec2-instance-connect" "3.1.1"
      "sha256-RDslReCA8S5us9+Y8pFOAK4xKff9XftcCdAnDzJoYgs=";

  types-aiobotocore-ecr =
    buildTypesAiobotocorePackage "ecr" "3.1.1"
      "sha256-FV7cY8YS4aeGH6dGN2pRQ8xPPKBbYMJ9aM7SPoVno0Q=";

  types-aiobotocore-ecr-public =
    buildTypesAiobotocorePackage "ecr-public" "3.1.1"
      "sha256-Tb+0296xPRw0V2iY7YGVWU6H/llGtcQK/5m76ls0c2c=";

  types-aiobotocore-ecs =
    buildTypesAiobotocorePackage "ecs" "3.1.1"
      "sha256-XugyQ7DDFcTwY4C42vHWHrox/+jTJnPgmd6abkJMINY=";

  types-aiobotocore-efs =
    buildTypesAiobotocorePackage "efs" "3.1.1"
      "sha256-50Un9Z6R4DeRPcoS4ACF0SpAYWsn179gYIfrfp1bDpM=";

  types-aiobotocore-eks =
    buildTypesAiobotocorePackage "eks" "3.1.1"
      "sha256-Ag9/hx7fXFEcgIEebZgncmDIXN9+f8j2PKd5tDrpHLY=";

  types-aiobotocore-elastic-inference =
    buildTypesAiobotocorePackage "elastic-inference" "2.20.0"
      "sha256-jFSY7JBVjDQi6dCqlX2LG7jxpSKfILv3XWbYidvtGos=";

  types-aiobotocore-elasticache =
    buildTypesAiobotocorePackage "elasticache" "3.1.1"
      "sha256-cMjWUp+m+Xnxr5m6pdzX7bwjSyIar5bvJtKExdIjBwI=";

  types-aiobotocore-elasticbeanstalk =
    buildTypesAiobotocorePackage "elasticbeanstalk" "3.1.1"
      "sha256-Qf8OL4VvshNmsi80a5cPl0BWGB76pEqw1I+oeL0/vNE=";

  types-aiobotocore-elastictranscoder =
    buildTypesAiobotocorePackage "elastictranscoder" "2.25.2"
      "sha256-5t214U60d2kSf8bmUiEkj4OMFf3+SbNRGqLif1Rj28E=";

  types-aiobotocore-elb =
    buildTypesAiobotocorePackage "elb" "3.1.1"
      "sha256-yogZLWnsvn0PEtN7kcwNhcQLs+xFy80YO2qM2VTDajM=";

  types-aiobotocore-elbv2 =
    buildTypesAiobotocorePackage "elbv2" "3.1.1"
      "sha256-GAqIVcHM5PnKt3GpEN3YnBhVVJIUhdWPUXP81nWVNHY=";

  types-aiobotocore-emr =
    buildTypesAiobotocorePackage "emr" "3.1.1"
      "sha256-/WhzJCP3CQWmG0H7orv++8lnHY0N6e8sSOV1vcGvFCI=";

  types-aiobotocore-emr-containers =
    buildTypesAiobotocorePackage "emr-containers" "3.1.1"
      "sha256-V49u67frOX834yUEQ8EJMK/FWOMN3ZGe6SobwTu954Q=";

  types-aiobotocore-emr-serverless =
    buildTypesAiobotocorePackage "emr-serverless" "3.1.1"
      "sha256-uaeD1ZymUgqb2O3vWONy62IKsraEoaHMJltR2VNWmiA=";

  types-aiobotocore-entityresolution =
    buildTypesAiobotocorePackage "entityresolution" "3.1.1"
      "sha256-ApIo6XIUmWhLnl/RDEMDJGUzoUxMyG6GqutmBKQZzBA=";

  types-aiobotocore-es =
    buildTypesAiobotocorePackage "es" "3.1.1"
      "sha256-+HtQ93rFG7IOmciPeqTtnTtNisWVcjfqQFl/veLxbp4=";

  types-aiobotocore-events =
    buildTypesAiobotocorePackage "events" "3.1.1"
      "sha256-ppz0XPiY4CuSKVz2kypznisTzIOlviurs2CmE7dRwbg=";

  types-aiobotocore-evidently =
    buildTypesAiobotocorePackage "evidently" "3.1.1"
      "sha256-g+XQEgqqZul8kOg0kstdYMvw2tu6zhC9GZGgs7WH3Mo=";

  types-aiobotocore-finspace =
    buildTypesAiobotocorePackage "finspace" "3.1.1"
      "sha256-91tfoDjQoRqrcEcvEhBpIoB01KCZGMptnhT1jPhwSLI=";

  types-aiobotocore-finspace-data =
    buildTypesAiobotocorePackage "finspace-data" "3.1.1"
      "sha256-ZdDgGAMDiy4OGMAwHPhvZup4XFYOL8eRhitk/9K7SZU=";

  types-aiobotocore-firehose =
    buildTypesAiobotocorePackage "firehose" "3.1.1"
      "sha256-Sj0btYoRtCwdsXVLVER+zjM7vkqS9x8bi7TXHJEwHsk=";

  types-aiobotocore-fis =
    buildTypesAiobotocorePackage "fis" "3.1.1"
      "sha256-oZbVOEvNzC765J5XnLmCkD4QlZRd+6CZR+bJ2p6ibWA=";

  types-aiobotocore-fms =
    buildTypesAiobotocorePackage "fms" "3.1.1"
      "sha256-uD67/fJl+JhLZS8xtr4rhjfeKf4vMA27x4xGJzsQiKI=";

  types-aiobotocore-forecast =
    buildTypesAiobotocorePackage "forecast" "3.1.1"
      "sha256-eZAMtbHi/kGw2oAjzatHHXtV2XO9dK6o2JXxEosJM/g=";

  types-aiobotocore-forecastquery =
    buildTypesAiobotocorePackage "forecastquery" "3.1.1"
      "sha256-BUN0WyLcMXL48o/z9vF3AgkXMkj4SAggfq33BemAsCE=";

  types-aiobotocore-frauddetector =
    buildTypesAiobotocorePackage "frauddetector" "3.1.1"
      "sha256-9+meGYgV6rC8Y8Qymtj0hWvpjlZReUBB4dym4B034bo=";

  types-aiobotocore-freetier =
    buildTypesAiobotocorePackage "freetier" "3.1.1"
      "sha256-LzJVHqaJUEnjQMM5Zjv7g8K5jixmssJ7mpmoDgNupr0=";

  types-aiobotocore-fsx =
    buildTypesAiobotocorePackage "fsx" "3.1.1"
      "sha256-0jXg5ywMfBEByF57McOf/9WD+VHLPNcNyNxLBMtoyBI=";

  types-aiobotocore-gamelift =
    buildTypesAiobotocorePackage "gamelift" "3.1.1"
      "sha256-xb92KmPUK9jcK4ALfZ2BT0W6wEYq+LhMMskmMIDCZWE=";

  types-aiobotocore-gamesparks =
    buildTypesAiobotocorePackage "gamesparks" "2.7.0"
      "sha256-oVbKtuLMPpCQcZYx/cH1Dqjv/t6/uXsveflfFVqfN+8=";

  types-aiobotocore-glacier =
    buildTypesAiobotocorePackage "glacier" "3.1.1"
      "sha256-R4vvIPDrO37M8Ob8mpPojNHTI9J7X1305GK68HKQJK0=";

  types-aiobotocore-globalaccelerator =
    buildTypesAiobotocorePackage "globalaccelerator" "3.1.1"
      "sha256-7NHbRGc0GNuEnQoNjt1AIbrilaBT0lski4/IzAUbVXs=";

  types-aiobotocore-glue =
    buildTypesAiobotocorePackage "glue" "3.1.1"
      "sha256-NH8DRpn8ySvLLadhahnn2ufkFklsvfFS3was5h5o56I=";

  types-aiobotocore-grafana =
    buildTypesAiobotocorePackage "grafana" "3.1.1"
      "sha256-BUsfLqM+ZXwgeu0tFrrCAtzwCr34mRQJXWHFiV3I3Fw=";

  types-aiobotocore-greengrass =
    buildTypesAiobotocorePackage "greengrass" "3.1.1"
      "sha256-VwBqqxzcOHJlOuopdVebGeHg8byujKgdBlZk4EvcYiE=";

  types-aiobotocore-greengrassv2 =
    buildTypesAiobotocorePackage "greengrassv2" "3.1.1"
      "sha256-xoTv+sTdjTodlRoeC3Zx0ZZ1Gffx8iNJ00eXPRIrNNk=";

  types-aiobotocore-groundstation =
    buildTypesAiobotocorePackage "groundstation" "3.1.1"
      "sha256-9FCCRyAt930MW00B6H3mEEIfgjc8sT6rFX3QdzW7HKI=";

  types-aiobotocore-guardduty =
    buildTypesAiobotocorePackage "guardduty" "3.1.1"
      "sha256-XX7YXw4y0xSbTcVnsJpol7UR3ZV5qpVlcvCtkP6Yu6s=";

  types-aiobotocore-health =
    buildTypesAiobotocorePackage "health" "3.1.1"
      "sha256-DM4VxmF1Ocz9tyeClVuqNniylCVgZ1dyupz2Pr5aA5A=";

  types-aiobotocore-healthlake =
    buildTypesAiobotocorePackage "healthlake" "3.1.1"
      "sha256-jfOzrgBa1zSCFxyoXmit/ODHKbFGJoO9OMFA0KAQh00=";

  types-aiobotocore-honeycode =
    buildTypesAiobotocorePackage "honeycode" "2.13.0"
      "sha256-DeeheoQeFEcDH21DSNs2kSR1rjnPLtTgz0yNCFnE+Io=";

  types-aiobotocore-iam =
    buildTypesAiobotocorePackage "iam" "3.1.1"
      "sha256-n9sndad94xwJ9E78XbCOOJ5bTxmUiKZ14SruaT3JQHg=";

  types-aiobotocore-identitystore =
    buildTypesAiobotocorePackage "identitystore" "3.1.1"
      "sha256-dy7SnosNkHban5PxAqbjA1KCwpBNQvrHTizCd/3iT2E=";

  types-aiobotocore-imagebuilder =
    buildTypesAiobotocorePackage "imagebuilder" "3.1.1"
      "sha256-Tw6ES0pPchxjFUHeGjhRFj64ym2cTInkb4EptIJpBeU=";

  types-aiobotocore-importexport =
    buildTypesAiobotocorePackage "importexport" "3.1.1"
      "sha256-qiXUAB5rL3f4dMpUFZOUa5N9zFJhTYXjYhE7eWW9umk=";

  types-aiobotocore-inspector =
    buildTypesAiobotocorePackage "inspector" "3.1.1"
      "sha256-7L/SppxIz+2JJ6LgzQEEBTMyqZs2LRrLvG23MGx5PGw=";

  types-aiobotocore-inspector2 =
    buildTypesAiobotocorePackage "inspector2" "3.1.1"
      "sha256-XkcmWvIhAwjeZvLM5J9Ns3r+i2BOrN+SLg7vjdOjG4k=";

  types-aiobotocore-internetmonitor =
    buildTypesAiobotocorePackage "internetmonitor" "3.1.1"
      "sha256-C0KPUEQwPq7unUsHEVgtl5jb9avF2/jRaKR3LMKvBaU=";

  types-aiobotocore-iot =
    buildTypesAiobotocorePackage "iot" "3.1.1"
      "sha256-uECrDJcFYUODeMCfrC8f0dj57oVKribPA+ClgYiWWZk=";

  types-aiobotocore-iot-data =
    buildTypesAiobotocorePackage "iot-data" "3.1.1"
      "sha256-SEHtsRKq8JzYhHyZh2gw6pOd6PxgVa7bU4hspoM3lK0=";

  types-aiobotocore-iot-jobs-data =
    buildTypesAiobotocorePackage "iot-jobs-data" "3.1.1"
      "sha256-+BYbu4Fdvz6l4rB3IQpFrTDuuduXxv6nPb1IsR1Iv1M=";

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
    buildTypesAiobotocorePackage "iotdeviceadvisor" "3.1.1"
      "sha256-t4ADzmTe2GlZOzxKg+0wzb3Om1KXiF5KsiqcTQ2Dlr8=";

  types-aiobotocore-iotevents =
    buildTypesAiobotocorePackage "iotevents" "3.1.1"
      "sha256-ribAg15KxQMCKeXkFoRXC68P5YgzEkl9icRnzmOASBY=";

  types-aiobotocore-iotevents-data =
    buildTypesAiobotocorePackage "iotevents-data" "3.1.1"
      "sha256-TKM5f8PpMzWOG7WKlp79Z1m8UmU+jV6IKw6Ttg8BPyM=";

  types-aiobotocore-iotfleethub =
    buildTypesAiobotocorePackage "iotfleethub" "2.24.2"
      "sha256-WzdCGMVRCl8x+UswlyApMYMYT3Rvtng0ID2YyV08NzA=";

  types-aiobotocore-iotfleetwise =
    buildTypesAiobotocorePackage "iotfleetwise" "3.1.1"
      "sha256-T2UfFaBxEPTU7O2Rjq6uqcaF3w25+yeZtOIoVACZoNA=";

  types-aiobotocore-iotsecuretunneling =
    buildTypesAiobotocorePackage "iotsecuretunneling" "3.1.1"
      "sha256-J+JDRyXPar1IK/7LzpHhZJjTVMlOvkLBIy7h2GghfL8=";

  types-aiobotocore-iotsitewise =
    buildTypesAiobotocorePackage "iotsitewise" "3.1.1"
      "sha256-nPSRxIdJwsOd2eZ92czbRrQRr0Sce301dYDuoANX7Sg=";

  types-aiobotocore-iotthingsgraph =
    buildTypesAiobotocorePackage "iotthingsgraph" "3.1.1"
      "sha256-mu5gEdtzoHZElnP5U7OArje99L/0AyEcoMac8Crl6fQ=";

  types-aiobotocore-iottwinmaker =
    buildTypesAiobotocorePackage "iottwinmaker" "3.1.1"
      "sha256-BYi7WZ6cgdKF44wpaQf+yTySMnZ1Tb6DNmrdfKF8woc=";

  types-aiobotocore-iotwireless =
    buildTypesAiobotocorePackage "iotwireless" "3.1.1"
      "sha256-zHz/XfXo78f2WUiPY/3K67s38JahcS0+d0F8w56ik18=";

  types-aiobotocore-ivs =
    buildTypesAiobotocorePackage "ivs" "3.1.1"
      "sha256-JqJ4fPFtkefMuCJ1K/jSnSo701YsozYIGz3ysvB2E2k=";

  types-aiobotocore-ivs-realtime =
    buildTypesAiobotocorePackage "ivs-realtime" "3.1.1"
      "sha256-jx/DqAPz4fREEGJaySfRK/VYL1miyvV/MXywmyxr5LU=";

  types-aiobotocore-ivschat =
    buildTypesAiobotocorePackage "ivschat" "3.1.1"
      "sha256-FwDxpP0T62gn11QLSfK/uNRtKpmX63K0IQORr+uPmvU=";

  types-aiobotocore-kafka =
    buildTypesAiobotocorePackage "kafka" "3.1.1"
      "sha256-VFXJnmUFR5amQETMT0KXjwIdjoWiAjx0/KytmFqjxNA=";

  types-aiobotocore-kafkaconnect =
    buildTypesAiobotocorePackage "kafkaconnect" "3.1.1"
      "sha256-uOizMqu/4gsyY+aQbaMdUWg7raxukPn/MtqFBW8Kbmg=";

  types-aiobotocore-kendra =
    buildTypesAiobotocorePackage "kendra" "3.1.1"
      "sha256-wmy+I+Q3tlp2h9fKrU1pQvcYqX/deQb198snvFE2XTw=";

  types-aiobotocore-kendra-ranking =
    buildTypesAiobotocorePackage "kendra-ranking" "3.1.1"
      "sha256-skYaLFofiYpTBLEIX2JYhE0wxvr3DbYHYNGH9YRBPO4=";

  types-aiobotocore-keyspaces =
    buildTypesAiobotocorePackage "keyspaces" "3.1.1"
      "sha256-o9AkLUE2ZyvvJa9fOwNkKIRwLQ8hEI/XF6W9yJ7g1WM=";

  types-aiobotocore-kinesis =
    buildTypesAiobotocorePackage "kinesis" "3.1.1"
      "sha256-NmUQMF6PrPg4FkYXbC6iyC12SiNJ7u33sA3fmyXbEr4=";

  types-aiobotocore-kinesis-video-archived-media =
    buildTypesAiobotocorePackage "kinesis-video-archived-media" "3.1.1"
      "sha256-Y0z2ukmCDuFa4qZWtoc7rj8/Hhh0ASMFY3wFI9xCeT0=";

  types-aiobotocore-kinesis-video-media =
    buildTypesAiobotocorePackage "kinesis-video-media" "3.1.1"
      "sha256-EC8/s+NbcMQBJ/uuGiDINiJQQFMuTS4DY4xZ2yIPp30=";

  types-aiobotocore-kinesis-video-signaling =
    buildTypesAiobotocorePackage "kinesis-video-signaling" "3.1.1"
      "sha256-/QqHPFOvSPMx+LPwvWC+G5aBH+bBG8hlz6x7ksC+VVM=";

  types-aiobotocore-kinesis-video-webrtc-storage =
    buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "3.1.1"
      "sha256-IJL++00bJoNolXDl3iOE0EKjc9oSi7wJJK3w/S31vFA=";

  types-aiobotocore-kinesisanalytics =
    buildTypesAiobotocorePackage "kinesisanalytics" "3.1.1"
      "sha256-HRWVpgdKqD2BJqBuRFflKQUi+II/tNnWDdCv9i0O21A=";

  types-aiobotocore-kinesisanalyticsv2 =
    buildTypesAiobotocorePackage "kinesisanalyticsv2" "3.1.1"
      "sha256-7+p62UiSq6UouX89LVPCGLXJLIdk340kw77BatgmiIc=";

  types-aiobotocore-kinesisvideo =
    buildTypesAiobotocorePackage "kinesisvideo" "3.1.1"
      "sha256-iJgLtaZuguBPqrpBbl8XCeB8L3YONFJs7Bcx0fT1BD4=";

  types-aiobotocore-kms =
    buildTypesAiobotocorePackage "kms" "3.1.1"
      "sha256-9KqXNCZC/Ll+axgQ6ISZsXeRbMSx1eiw51YVoEkTULA=";

  types-aiobotocore-lakeformation =
    buildTypesAiobotocorePackage "lakeformation" "3.1.1"
      "sha256-Ie0AIzE7FbjQNNJrKWuEre/caIuhgD4XYVHUn8KEOhQ=";

  types-aiobotocore-lambda =
    buildTypesAiobotocorePackage "lambda" "3.1.1"
      "sha256-P4VgxLV5cD1bBHNTtSEWgT6URSfm8FaohsK86wJY68s=";

  types-aiobotocore-lex-models =
    buildTypesAiobotocorePackage "lex-models" "3.1.1"
      "sha256-NI5cDtptyAr5unDsiS3keghxZvA+07Oqc7EIUEEAYgc=";

  types-aiobotocore-lex-runtime =
    buildTypesAiobotocorePackage "lex-runtime" "3.1.1"
      "sha256-qYg/L6Ojc6cCNQ7O1+XyAVrZnnOje5aQvHch0rnN93k=";

  types-aiobotocore-lexv2-models =
    buildTypesAiobotocorePackage "lexv2-models" "3.1.1"
      "sha256-kHF1aE/z+Dvmf/km/qm9Zd9TrKXjU4i0UQ9a0BicG8I=";

  types-aiobotocore-lexv2-runtime =
    buildTypesAiobotocorePackage "lexv2-runtime" "3.1.1"
      "sha256-2+rCKwWQdlV9EH0+b0iCMOgQKfzl2OMFscWu5oCZKrM=";

  types-aiobotocore-license-manager =
    buildTypesAiobotocorePackage "license-manager" "3.1.1"
      "sha256-WZVMql96LyLsawY70m6O8U4sJmJz7l3y4Ts2TbXNYkQ=";

  types-aiobotocore-license-manager-linux-subscriptions =
    buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "3.1.1"
      "sha256-ycMCdu3hCU9EHUkjzPj6gjNAWIVajOioMFo968ersPA=";

  types-aiobotocore-license-manager-user-subscriptions =
    buildTypesAiobotocorePackage "license-manager-user-subscriptions" "3.1.1"
      "sha256-xxmcCG/Us8WfcIThW857iD+1m4Q4cLQkvnqpjBydEZw=";

  types-aiobotocore-lightsail =
    buildTypesAiobotocorePackage "lightsail" "3.1.1"
      "sha256-yiBpTNnLHaXYh1GIPcAjTPmVoTcfdPX19iMcQAaMSqY=";

  types-aiobotocore-location =
    buildTypesAiobotocorePackage "location" "3.1.1"
      "sha256-wEPtBnzLrITVYHRyTiovD7giY+KmwsB5WRGFOz4iOic=";

  types-aiobotocore-logs =
    buildTypesAiobotocorePackage "logs" "3.1.1"
      "sha256-f0ZOlNmGdtYm2PLkiIlKaTcfksxXdejsjVmXbVdriH0=";

  types-aiobotocore-lookoutequipment =
    buildTypesAiobotocorePackage "lookoutequipment" "3.1.1"
      "sha256-KkI39r2VShirYFylvSZGRwHqtt83zteWHwAxabDxmnY=";

  types-aiobotocore-lookoutmetrics =
    buildTypesAiobotocorePackage "lookoutmetrics" "2.24.2"
      "sha256-u84KeWwmp42KajZ3HnztG1106RN4dGh3jcMfSkJYXNY=";

  types-aiobotocore-lookoutvision =
    buildTypesAiobotocorePackage "lookoutvision" "2.24.2"
      "sha256-HvNqynXLpYFJceCmrlncodqWuoczilMB8QtbCS5pcDM=";

  types-aiobotocore-m2 =
    buildTypesAiobotocorePackage "m2" "3.1.1"
      "sha256-jUXB9bhdcsBzMGR0r2Zbg8+1k+B75kwS7Ltd5ZJjgDA=";

  types-aiobotocore-machinelearning =
    buildTypesAiobotocorePackage "machinelearning" "3.1.1"
      "sha256-+ON6bHoN69LT7fnHSH6ABEQ2n2ihOVdgkLhQC7GSplk=";

  types-aiobotocore-macie =
    buildTypesAiobotocorePackage "macie" "2.7.0"
      "sha256-hJJtGsK2b56nKX1ZhiarC+ffyjHYWRiC8II4oyDZWWw=";

  types-aiobotocore-macie2 =
    buildTypesAiobotocorePackage "macie2" "3.1.1"
      "sha256-wUxSvhQ61WMClqjy4pvcqyEqHAyLZPT58xAWHS7uCxU=";

  types-aiobotocore-managedblockchain =
    buildTypesAiobotocorePackage "managedblockchain" "3.1.1"
      "sha256-PGEMouhVZS3LQHcsT49j/nvm8GG7yUezlkpAbh+0Ejo=";

  types-aiobotocore-managedblockchain-query =
    buildTypesAiobotocorePackage "managedblockchain-query" "3.1.1"
      "sha256-S9LulFwqCi8hVmlP5Fdtp/8XaX+4F4KWXdqzCklzTmE=";

  types-aiobotocore-marketplace-catalog =
    buildTypesAiobotocorePackage "marketplace-catalog" "3.1.1"
      "sha256-BzzG6RxTge3OZMNz9OetB26/CyR+EIqFrlS6fXN+hsA=";

  types-aiobotocore-marketplace-entitlement =
    buildTypesAiobotocorePackage "marketplace-entitlement" "3.1.1"
      "sha256-gkmEK5hm375K80q3NpNGI3jp32NjXbvarpHVIPZ0YkM=";

  types-aiobotocore-marketplacecommerceanalytics =
    buildTypesAiobotocorePackage "marketplacecommerceanalytics" "3.1.1"
      "sha256-yCAgw+kNkvokhcl1TnPmGoX1zUgn7s7zboxq9ZKK6oQ=";

  types-aiobotocore-mediaconnect =
    buildTypesAiobotocorePackage "mediaconnect" "3.1.1"
      "sha256-cnE/gH17joqGxBQ4pgpIRJMC6Nukef8JFFMVqe0PiIU=";

  types-aiobotocore-mediaconvert =
    buildTypesAiobotocorePackage "mediaconvert" "3.1.1"
      "sha256-9FCwpmXZJRu987K3mnlBj/mgUOEx56RT3rwKgFcVzgM=";

  types-aiobotocore-medialive =
    buildTypesAiobotocorePackage "medialive" "3.1.1"
      "sha256-IY2PZHwBLpEcsFmbZrwqpj6ODdYZXpdPoPeoTBCJ6Us=";

  types-aiobotocore-mediapackage =
    buildTypesAiobotocorePackage "mediapackage" "3.1.1"
      "sha256-8GVz1U7Nfhqftifs2i2vYMA76BxJvN25jefHruWU7nE=";

  types-aiobotocore-mediapackage-vod =
    buildTypesAiobotocorePackage "mediapackage-vod" "3.1.1"
      "sha256-raiCQ7xu4wpx90MrMOd2WzlHQfts3eydsB8Sap24jnM=";

  types-aiobotocore-mediapackagev2 =
    buildTypesAiobotocorePackage "mediapackagev2" "3.1.1"
      "sha256-HSUY3KPPXX9nquBc08wwxJbDLdhOFU5d5BQ1rR6JL/M=";

  types-aiobotocore-mediastore =
    buildTypesAiobotocorePackage "mediastore" "3.1.1"
      "sha256-3Icr1+QkDqGfCULoouiuVrdksBnOgJNwdDmKw9/mnm0=";

  types-aiobotocore-mediastore-data =
    buildTypesAiobotocorePackage "mediastore-data" "3.1.1"
      "sha256-5jvXU6axVfGUxaKpIWRl0PoMJy/+AgdqkfB3lqs6snw=";

  types-aiobotocore-mediatailor =
    buildTypesAiobotocorePackage "mediatailor" "3.1.1"
      "sha256-I64+448b1NnovLESYBprXqwbYl2LfUTTV3uq+HdIMCE=";

  types-aiobotocore-medical-imaging =
    buildTypesAiobotocorePackage "medical-imaging" "3.1.1"
      "sha256-HpHRaJh9PskEMzPTZZskV7A+0NPXt9lAWFELBrQ09eU=";

  types-aiobotocore-memorydb =
    buildTypesAiobotocorePackage "memorydb" "3.1.1"
      "sha256-7TqwAPZICoOS4812eD7+kFQbGtnAIpgEcG+hXKUAkAY=";

  types-aiobotocore-meteringmarketplace =
    buildTypesAiobotocorePackage "meteringmarketplace" "3.1.1"
      "sha256-f9zacDyz8v12K8dtha35z0b7o95ruExiUAclf9RZ7HY=";

  types-aiobotocore-mgh =
    buildTypesAiobotocorePackage "mgh" "3.1.1"
      "sha256-2FSNcXUOufGNSJxfaoUtdud/I6/kK96TutQ3nSdUjQQ=";

  types-aiobotocore-mgn =
    buildTypesAiobotocorePackage "mgn" "3.1.1"
      "sha256-xty4Av76wv75peSMCmZBKD6+PVV4GVINKSssaEN3Oyc=";

  types-aiobotocore-migration-hub-refactor-spaces =
    buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "3.1.1"
      "sha256-/v1A8tgSfVMCaRKB61fVfIQxHiJQVH02ynmt5CcEER0=";

  types-aiobotocore-migrationhub-config =
    buildTypesAiobotocorePackage "migrationhub-config" "3.1.1"
      "sha256-5sXvRJSN61x283/aNblJeHV3O4Q5NV5joN1LV3hKrcs=";

  types-aiobotocore-migrationhuborchestrator =
    buildTypesAiobotocorePackage "migrationhuborchestrator" "3.1.1"
      "sha256-dSXP0nKFVH8SqnHkEUqso/HzmL/yp20OhZ6ESuj91So=";

  types-aiobotocore-migrationhubstrategy =
    buildTypesAiobotocorePackage "migrationhubstrategy" "3.1.1"
      "sha256-Q6txW7m8uFu4i7hspZwW1YEK/enrVkQRqaTM9WHX8kE=";

  types-aiobotocore-mobile =
    buildTypesAiobotocorePackage "mobile" "2.13.2"
      "sha256-OxB91BCAmYnY72JBWZaBlEkpAxN2Q5aY4i1Pt3eD9hc=";

  types-aiobotocore-mq =
    buildTypesAiobotocorePackage "mq" "3.1.1"
      "sha256-cFe2c2qh7KMjolRVu3dCXaSnVJDl8+MmagpfeQbULcg=";

  types-aiobotocore-mturk =
    buildTypesAiobotocorePackage "mturk" "3.1.1"
      "sha256-ro8rgylUR3sD8oBQA3lJaAWONvLdENhU00fDAcdm5EU=";

  types-aiobotocore-mwaa =
    buildTypesAiobotocorePackage "mwaa" "3.1.1"
      "sha256-EwHU03wwyvHTWmSFlY5p5AqkjSbbkp+ya+dvN5F75uw=";

  types-aiobotocore-neptune =
    buildTypesAiobotocorePackage "neptune" "3.1.1"
      "sha256-ystvIXoNzceZgttIEn0UZHV/fstjhewIdpmrWTav3x8=";

  types-aiobotocore-network-firewall =
    buildTypesAiobotocorePackage "network-firewall" "3.1.1"
      "sha256-0LVYzJNtvKdF7yFUDHtXri/hmT+zOYHTPCzdGfarCHc=";

  types-aiobotocore-networkmanager =
    buildTypesAiobotocorePackage "networkmanager" "3.1.1"
      "sha256-a48zAw0Sf3obnuG1IzsB3747Zj74PD1ttwJt9BrojsU=";

  types-aiobotocore-networkmonitor =
    buildTypesAiobotocorePackage "networkmonitor" "3.1.1"
      "sha256-MgVX1qMWFw8UN2SyjNJzLX9Y30lhgfwjKNu39X5ojwo=";

  types-aiobotocore-nimble =
    buildTypesAiobotocorePackage "nimble" "2.15.2"
      "sha256-PChX5Jbgr0d1YaTZU9AbX3cM7NrhkyunK6/X3l+I8Q0=";

  types-aiobotocore-oam =
    buildTypesAiobotocorePackage "oam" "3.1.1"
      "sha256-khmCr1dPEhksIS4bMp9FsTVH+I2MU/CACDq1fF6uT6o=";

  types-aiobotocore-omics =
    buildTypesAiobotocorePackage "omics" "3.1.1"
      "sha256-t3wuO156c1bpM/RYqaJDBKABY+nfyEHwiEFxxiwzihU=";

  types-aiobotocore-opensearch =
    buildTypesAiobotocorePackage "opensearch" "3.1.1"
      "sha256-5dsBvDllvNFSNMwq06x62rusCIkmENpKryBZ0qLRJQM=";

  types-aiobotocore-opensearchserverless =
    buildTypesAiobotocorePackage "opensearchserverless" "3.1.1"
      "sha256-wBN7GgJKAY0++uvg98D/zeXk/qhViDIp335ctrgkBTA=";

  types-aiobotocore-opsworks =
    buildTypesAiobotocorePackage "opsworks" "2.24.2"
      "sha256-ScEMFhogJRX6ykymK3rqYniGVcyJEsECKvnnbT3xv1A=";

  types-aiobotocore-opsworkscm =
    buildTypesAiobotocorePackage "opsworkscm" "2.24.2"
      "sha256-i+qoE5XXWpZ7dQeDagkD2MhnBjwbKTJYyZxATDh8h9M=";

  types-aiobotocore-organizations =
    buildTypesAiobotocorePackage "organizations" "3.1.1"
      "sha256-9mSsZoNFZRxfqYu3a+JAAst6SFm4oQTKbjSpaaevBj4=";

  types-aiobotocore-osis =
    buildTypesAiobotocorePackage "osis" "3.1.1"
      "sha256-dg7yfjkQhSeJ6Ukq+vuPchTPPhHN9GSVQXcH5nxOD74=";

  types-aiobotocore-outposts =
    buildTypesAiobotocorePackage "outposts" "3.1.1"
      "sha256-m6RptDmaOsg3IuG6njvsLEPjlvBoG4WAS8/TiRla0Nc=";

  types-aiobotocore-panorama =
    buildTypesAiobotocorePackage "panorama" "3.1.1"
      "sha256-n6xv1XtGzS47T0mfRjG2sOpjDr4odL76sRnFatnLJYs=";

  types-aiobotocore-payment-cryptography =
    buildTypesAiobotocorePackage "payment-cryptography" "3.1.1"
      "sha256-uocATok9fdU0PEwUhEG3xNb8Imzhv93akNO5T4+UPMM=";

  types-aiobotocore-payment-cryptography-data =
    buildTypesAiobotocorePackage "payment-cryptography-data" "3.1.1"
      "sha256-ywoIU/Qgl6GsA5+438hwgkTqWFgy8zat5yVDkBGYg5A=";

  types-aiobotocore-personalize =
    buildTypesAiobotocorePackage "personalize" "3.1.1"
      "sha256-vIg2Hxh9aqepicRFxlNUukLsuu6MiEpc/p48bgKqK1c=";

  types-aiobotocore-personalize-events =
    buildTypesAiobotocorePackage "personalize-events" "3.1.1"
      "sha256-8FoAZtUWxNA3iFqyfeYO/yJb02XbmDKlVYYgUuC9Zuc=";

  types-aiobotocore-personalize-runtime =
    buildTypesAiobotocorePackage "personalize-runtime" "3.1.1"
      "sha256-j47P2WctXxiyAXhp8ymPBFQfvSqee8sxsAYym7gghhE=";

  types-aiobotocore-pi =
    buildTypesAiobotocorePackage "pi" "3.1.1"
      "sha256-LIxeYK6y55H3IoF4Sv/UZZBVAU/8m/t+rBdy/ZQlabk=";

  types-aiobotocore-pinpoint =
    buildTypesAiobotocorePackage "pinpoint" "3.1.1"
      "sha256-plNFu+sghU1naHY9btk41GRk6MrHKuEJ9tHnPGydj6M=";

  types-aiobotocore-pinpoint-email =
    buildTypesAiobotocorePackage "pinpoint-email" "3.1.1"
      "sha256-0WRy+7saj7k+N8kDXafwFnBbagq1WlrGcyXXFyJ9hdE=";

  types-aiobotocore-pinpoint-sms-voice =
    buildTypesAiobotocorePackage "pinpoint-sms-voice" "3.1.1"
      "sha256-OKMJ/cVT2QauXzP/QcnZlVaoFOY+nyirtEZrEJrvH4A=";

  types-aiobotocore-pinpoint-sms-voice-v2 =
    buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "3.1.1"
      "sha256-ZrUkbnXjRyw6WDW8QxhP8k5055wip1Ne03L1L3AsmeM=";

  types-aiobotocore-pipes =
    buildTypesAiobotocorePackage "pipes" "3.1.1"
      "sha256-m3mjnwr3mkWYThcVIKCepvXUXBm7Qnui7kjTQV/uCvE=";

  types-aiobotocore-polly =
    buildTypesAiobotocorePackage "polly" "3.1.1"
      "sha256-p+BH4d/JXfvLZckTXdM/cJswgE7CiB4GBbZHqJSCqCU=";

  types-aiobotocore-pricing =
    buildTypesAiobotocorePackage "pricing" "3.1.1"
      "sha256-tCgFEmAhYH+EpzRt8qnsf+clVvdMlFESg6ZW9xAq6pk=";

  types-aiobotocore-privatenetworks =
    buildTypesAiobotocorePackage "privatenetworks" "2.22.0"
      "sha256-yaYvgVKcr3l2eq0dMzmQEZHxgblTLlVF9cZRnObiB7M=";

  types-aiobotocore-proton =
    buildTypesAiobotocorePackage "proton" "3.1.1"
      "sha256-BKC/3AH88cmY51yEXU4N7M2YpmSazg1mCqes+v+LtCU=";

  types-aiobotocore-qapps =
    buildTypesAiobotocorePackage "qapps" "3.1.1"
      "sha256-Y6egSNGNRx1aaLfm+q1PkHW+dSIYpnU7I0Nq1B/1G8A=";

  types-aiobotocore-qbusiness =
    buildTypesAiobotocorePackage "qbusiness" "3.1.1"
      "sha256-WV0XXL48qg7gZu6SCpiKPKBR2DdSmLPE1emTGtPtTH8=";

  types-aiobotocore-qconnect =
    buildTypesAiobotocorePackage "qconnect" "3.1.1"
      "sha256-q/vHlhRNIvJt7nPNeJMX+5q3HhIdeh2k7u4z7Vzoaw8=";

  types-aiobotocore-qldb =
    buildTypesAiobotocorePackage "qldb" "2.24.2"
      "sha256-qrSbXgc4DBb2kNg0ydb1vT9EmRqQWNIfuNOVsK8BPY0=";

  types-aiobotocore-qldb-session =
    buildTypesAiobotocorePackage "qldb-session" "2.24.2"
      "sha256-Lk9RLigcg4F/AsgKneBUoyPyeUh46ra+BLCw94b74eU=";

  types-aiobotocore-quicksight =
    buildTypesAiobotocorePackage "quicksight" "3.1.1"
      "sha256-T6FiUtwNTsMa/3RMEA3/4gXwpvAAJvl2qH3u+50ozIk=";

  types-aiobotocore-ram =
    buildTypesAiobotocorePackage "ram" "3.1.1"
      "sha256-b0bm9rvM4kBRIHmxc2ARvHZ6Qhh636CRpXlxNVk92p0=";

  types-aiobotocore-rbin =
    buildTypesAiobotocorePackage "rbin" "3.1.1"
      "sha256-EyjZ/2pDSa+AXS5lN1udGemFtXaQGwaJY7Pv6BvmwqE=";

  types-aiobotocore-rds =
    buildTypesAiobotocorePackage "rds" "3.1.1"
      "sha256-FFEHie64KT8vmBtQ24ddzQxDmtkriJR1GRA7C4fOxVk=";

  types-aiobotocore-rds-data =
    buildTypesAiobotocorePackage "rds-data" "3.1.1"
      "sha256-hVC82OG2dZIJGllWfLgQyM1e44HEtK1PGuNXcCDdmgQ=";

  types-aiobotocore-redshift =
    buildTypesAiobotocorePackage "redshift" "3.1.1"
      "sha256-8p2F55suy6sJmpXvLZ2XrfW00hw+nIJeeVqOTx4Hk5k=";

  types-aiobotocore-redshift-data =
    buildTypesAiobotocorePackage "redshift-data" "3.1.1"
      "sha256-7LjGSidm6AP+lAJyxsQtyCF3c6jB5cUvXfqxzMp9y18=";

  types-aiobotocore-redshift-serverless =
    buildTypesAiobotocorePackage "redshift-serverless" "3.1.1"
      "sha256-u+Va+MEMXAcPaSxvryCVTpKyPdTar0AdpZGNCInzkgU=";

  types-aiobotocore-rekognition =
    buildTypesAiobotocorePackage "rekognition" "3.1.1"
      "sha256-U/KVbFTlIfKaBSAevzSMpihvSflCScpCT6fdTUwnbcQ=";

  types-aiobotocore-resiliencehub =
    buildTypesAiobotocorePackage "resiliencehub" "3.1.1"
      "sha256-c1zMuR9faLmlHRSgx/LTVEr1GejxeCyToTRXqKwyUtA=";

  types-aiobotocore-resource-explorer-2 =
    buildTypesAiobotocorePackage "resource-explorer-2" "3.1.1"
      "sha256-2qBAz5uIVOKU5506JiKHF9gI5X4h4Zz8BnKAxn5+Ork=";

  types-aiobotocore-resource-groups =
    buildTypesAiobotocorePackage "resource-groups" "3.1.1"
      "sha256-qakIWZDujyL1nrqVAujEY7gEw06Rh5ZrTKMwwjZjwZw=";

  types-aiobotocore-resourcegroupstaggingapi =
    buildTypesAiobotocorePackage "resourcegroupstaggingapi" "3.1.1"
      "sha256-U6M0V4rnU9CdlwTaYtd8uXdtPm2WHiirTzqE19Yk/4A=";

  types-aiobotocore-robomaker =
    buildTypesAiobotocorePackage "robomaker" "2.24.2"
      "sha256-EczunxMisSO9t2iYzXuzTeFiNalu2EyDRIOE7TW5fOg=";

  types-aiobotocore-rolesanywhere =
    buildTypesAiobotocorePackage "rolesanywhere" "3.1.1"
      "sha256-x1nXEe64uz1OXNTj+LEjl6Xo5QS4/53qywFa6HP7diw=";

  types-aiobotocore-route53 =
    buildTypesAiobotocorePackage "route53" "3.1.1"
      "sha256-YiR4+/8JsuWDgTH5iLK9LpXc5BWusLAMAxmi50BR4Gc=";

  types-aiobotocore-route53-recovery-cluster =
    buildTypesAiobotocorePackage "route53-recovery-cluster" "3.1.1"
      "sha256-A6eq6sE5xDZeycGMNxLh/UA/Uj+mbMVm0xOPw+HQ2mQ=";

  types-aiobotocore-route53-recovery-control-config =
    buildTypesAiobotocorePackage "route53-recovery-control-config" "3.1.1"
      "sha256-9R8D+jq4sRY4NWZ487LJT7rAzQ6/LyFVlPskJp+Dq0c=";

  types-aiobotocore-route53-recovery-readiness =
    buildTypesAiobotocorePackage "route53-recovery-readiness" "3.1.1"
      "sha256-LmEs3Xz1ELh0UPAy0Yu6PwU4Ogz5GnPPqg5tn067jAA=";

  types-aiobotocore-route53domains =
    buildTypesAiobotocorePackage "route53domains" "3.1.1"
      "sha256-0wtwVlAHi9agn+2RhmvfbJlfq9zi3ZWnVUvm2qjaUTQ=";

  types-aiobotocore-route53resolver =
    buildTypesAiobotocorePackage "route53resolver" "3.1.1"
      "sha256-i4bfFGnSbIBD9necbure2NumPQBhkcDJk/T/6CAbkyA=";

  types-aiobotocore-rum =
    buildTypesAiobotocorePackage "rum" "3.1.1"
      "sha256-nTxbVfCTj6omj2R1UOHIuarItcpN2M7Q6Vs+pa0RJJs=";

  types-aiobotocore-s3 =
    buildTypesAiobotocorePackage "s3" "3.1.1"
      "sha256-5/S6ZHKjJLh0Q1zeuYb1awtHgGkE4n/cclH1QM6dYs0=";

  types-aiobotocore-s3control =
    buildTypesAiobotocorePackage "s3control" "3.1.1"
      "sha256-0ueIW+9239grzVj3dU0fPrTZRlEsEsnfUllvO0aWLLA=";

  types-aiobotocore-s3outposts =
    buildTypesAiobotocorePackage "s3outposts" "3.1.1"
      "sha256-U0r+tuv0Q8VMKVaDaQBS8dW0dXZMz6Va3X6ESQY43+g=";

  types-aiobotocore-sagemaker =
    buildTypesAiobotocorePackage "sagemaker" "3.1.1"
      "sha256-8ZbSi+4qJ4cE01E5CkLz37x/YyUc2t985HugrF1CNIA=";

  types-aiobotocore-sagemaker-a2i-runtime =
    buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "3.1.1"
      "sha256-LFcrIvF++PPQKPF+SwUd9lWYHD99JPE9OmaObG0fWzM=";

  types-aiobotocore-sagemaker-edge =
    buildTypesAiobotocorePackage "sagemaker-edge" "3.1.1"
      "sha256-HNeG89qLcU+Jow39qt1hy4Bl718UjPAZe1jFSTnRU+U=";

  types-aiobotocore-sagemaker-featurestore-runtime =
    buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "3.1.1"
      "sha256-BXqKsUMuOllA3ZX9a3QXnylfzv8AlBNO6xHP8OzKNaA=";

  types-aiobotocore-sagemaker-geospatial =
    buildTypesAiobotocorePackage "sagemaker-geospatial" "3.1.1"
      "sha256-b+bORsJUj8RNVuQ/t/vjQdfuojlDRfLyf4a0hh05i9I=";

  types-aiobotocore-sagemaker-metrics =
    buildTypesAiobotocorePackage "sagemaker-metrics" "3.1.1"
      "sha256-e1Td6SS4lkUGb4pGw8dLh0fwk8IuQDHoePdelArhTuw=";

  types-aiobotocore-sagemaker-runtime =
    buildTypesAiobotocorePackage "sagemaker-runtime" "3.1.1"
      "sha256-mfmUnIWDHJrbtR46Cswmp4EFCS3Sx2f9BAS/CtS7FmY=";

  types-aiobotocore-savingsplans =
    buildTypesAiobotocorePackage "savingsplans" "3.1.1"
      "sha256-DMLWYNvYZO9wKiYUOQ5CEb1OleeHeLvwQBuvM1la7fo=";

  types-aiobotocore-scheduler =
    buildTypesAiobotocorePackage "scheduler" "3.1.1"
      "sha256-cHXK35sAqY7PmRLIzGJvhUue8q9PDsriKd6kf86RMt8=";

  types-aiobotocore-schemas =
    buildTypesAiobotocorePackage "schemas" "3.1.1"
      "sha256-Ef/CKyJpHiz2/4TVnCv+CtFU52EQ/zljuC58qZ3Apa8=";

  types-aiobotocore-sdb =
    buildTypesAiobotocorePackage "sdb" "3.1.1"
      "sha256-yrKi1uHlaV2Ze2nR8/CSMI8bPVMg6FhaR+LwOGuJ0FQ=";

  types-aiobotocore-secretsmanager =
    buildTypesAiobotocorePackage "secretsmanager" "3.1.1"
      "sha256-AUmFSodtBXV9OlC/ynO5gky20ubcmmdSwdJ1oxfXqLY=";

  types-aiobotocore-securityhub =
    buildTypesAiobotocorePackage "securityhub" "3.1.1"
      "sha256-GxMUqlS8qNUFML4yer1q8EbtvzSt/GeYec6U6PKna2U=";

  types-aiobotocore-securitylake =
    buildTypesAiobotocorePackage "securitylake" "3.1.1"
      "sha256-EYLRzIkCSX1ZPkm2KP/swE+lD63dSLrb2PC01z8TIPI=";

  types-aiobotocore-serverlessrepo =
    buildTypesAiobotocorePackage "serverlessrepo" "3.1.1"
      "sha256-BxN5PgJgUaJ+RVHKDjiFVcHOUvId8ztz6I/mqj3dV6Q=";

  types-aiobotocore-service-quotas =
    buildTypesAiobotocorePackage "service-quotas" "3.1.1"
      "sha256-/yRZzfHbLLmoS2JY3E9Gt4D9GnS+2S2GnVqFc17V620=";

  types-aiobotocore-servicecatalog =
    buildTypesAiobotocorePackage "servicecatalog" "3.1.1"
      "sha256-rS5SR6uJDYLHsPM5peDU4gum9shrVXLkaLVzENbFTqU=";

  types-aiobotocore-servicecatalog-appregistry =
    buildTypesAiobotocorePackage "servicecatalog-appregistry" "3.1.1"
      "sha256-/iRL4THgfVXdI3Dp74Q5BGDFpHt++KLboQbn8DAmMOg=";

  types-aiobotocore-servicediscovery =
    buildTypesAiobotocorePackage "servicediscovery" "3.1.1"
      "sha256-F+f7YeOO2Jsw+5DsS6new6vmWA9RopdyzfC41+IsLUc=";

  types-aiobotocore-ses =
    buildTypesAiobotocorePackage "ses" "3.1.1"
      "sha256-9NpTtA5gSHkzIK36eJlpMcImplJKWC56NQm8x+pb/3E=";

  types-aiobotocore-sesv2 =
    buildTypesAiobotocorePackage "sesv2" "3.1.1"
      "sha256-EsZdps9wrSW7dl6B7cM5Ur04nlkvFJZPTma6UI6Y4g0=";

  types-aiobotocore-shield =
    buildTypesAiobotocorePackage "shield" "3.1.1"
      "sha256-l5VGTIkl8f5wmHzMYaJ1inuB5aiNMrWPPNAMuFUKoM8=";

  types-aiobotocore-signer =
    buildTypesAiobotocorePackage "signer" "3.1.1"
      "sha256-LkXSPGq2lGibp/5rIk06+rHYzVd0GmGeR3vD4pIbjaw=";

  types-aiobotocore-simspaceweaver =
    buildTypesAiobotocorePackage "simspaceweaver" "3.1.1"
      "sha256-4EZYXzMC4tKcZPdVH1Tkc19Vv9md49Xbbl7hdHzh7uI=";

  types-aiobotocore-sms =
    buildTypesAiobotocorePackage "sms" "2.24.2"
      "sha256-aZuGmKtxe3ERjMUZ5jNiZUaVUqDaCHKQQ6wMTsGkcVs=";

  types-aiobotocore-sms-voice =
    buildTypesAiobotocorePackage "sms-voice" "2.22.0"
      "sha256-nlg8QppdMa4MMLUQZXcxnypzv5II9PqEtuVc09UmjKU=";

  types-aiobotocore-snow-device-management =
    buildTypesAiobotocorePackage "snow-device-management" "3.1.1"
      "sha256-/NwzS9U1t4//pCorM5/FIOAlNBZb+2+RnY9fgTTMb6g=";

  types-aiobotocore-snowball =
    buildTypesAiobotocorePackage "snowball" "3.1.1"
      "sha256-9UfBPLwXXGljN7gDfy41ujtS38l7XdgQhrRNIfbUQMw=";

  types-aiobotocore-sns =
    buildTypesAiobotocorePackage "sns" "3.1.1"
      "sha256-cT+F0l1Vbvqfam30qJRLrX/4BCv1/mJd4JfGfIPIilI=";

  types-aiobotocore-sqs =
    buildTypesAiobotocorePackage "sqs" "3.1.1"
      "sha256-ueacBQwvInwLWNiqVJ0Vw7Nw/o2XZgsQjzpCeuqqtzU=";

  types-aiobotocore-ssm =
    buildTypesAiobotocorePackage "ssm" "3.1.1"
      "sha256-LyHpJdWhdW8PYgiOHRlOmLNO4+6Ky7xrrim9/s5jH0k=";

  types-aiobotocore-ssm-contacts =
    buildTypesAiobotocorePackage "ssm-contacts" "3.1.1"
      "sha256-oTFfGAL2S6hTM8cwQLMcZXjSpyRf3QN1m50a2Px0FBw=";

  types-aiobotocore-ssm-incidents =
    buildTypesAiobotocorePackage "ssm-incidents" "3.1.1"
      "sha256-9vyFo4pS4SobbbCCuwQOlW/VBF2yesnX59GsgdsO+KY=";

  types-aiobotocore-ssm-sap =
    buildTypesAiobotocorePackage "ssm-sap" "3.1.1"
      "sha256-tP3465vsX842Ftut8n1ntio34SRX/UekFj8VYSCRO5w=";

  types-aiobotocore-sso =
    buildTypesAiobotocorePackage "sso" "3.1.1"
      "sha256-JhLvoJgs4y8e26VT6ZZkOiY1I/SNin1/JthaFPc4OJE=";

  types-aiobotocore-sso-admin =
    buildTypesAiobotocorePackage "sso-admin" "3.1.1"
      "sha256-1KfctJkmFUdfAnFDYp2skGeNRvlZUG4cEKOtie1lP0A=";

  types-aiobotocore-sso-oidc =
    buildTypesAiobotocorePackage "sso-oidc" "3.1.1"
      "sha256-+UALlB9RKGXMnlIMSoKsd1l4JuxFtKTJmZke9C1S0zc=";

  types-aiobotocore-stepfunctions =
    buildTypesAiobotocorePackage "stepfunctions" "3.1.1"
      "sha256-JcBvWSojGhqmuqBxyp4Nh/knTWylxPK6GrBKRoa82uk=";

  types-aiobotocore-storagegateway =
    buildTypesAiobotocorePackage "storagegateway" "3.1.1"
      "sha256-X3J+W9OzZT8JBzJwaVKeKvgEDNaEJLGV7BYDC1Bsj/w=";

  types-aiobotocore-sts =
    buildTypesAiobotocorePackage "sts" "3.1.1"
      "sha256-SrM3vsUMyY2tlm4keqt15GSBl5C4OAVZ3kcwHZVV8PA=";

  types-aiobotocore-support =
    buildTypesAiobotocorePackage "support" "3.1.1"
      "sha256-uqLjAu3V5y25x1MZmPWiKtqo4fHtFNsUKQ7qzgMJJbk=";

  types-aiobotocore-support-app =
    buildTypesAiobotocorePackage "support-app" "3.1.1"
      "sha256-dt58V9rl7OFuKbrC/IEn/oHmaSo3yb5OlZIuFB6EENA=";

  types-aiobotocore-swf =
    buildTypesAiobotocorePackage "swf" "3.1.1"
      "sha256-IQSwkrDhSoQ3pdLaQaaJCEPSAYc84Al+C7Wy83tbI+4=";

  types-aiobotocore-synthetics =
    buildTypesAiobotocorePackage "synthetics" "3.1.1"
      "sha256-IJo8z/lEc9acZLKPBYg/f/2+zMSee6Tviti5QVOTa8w=";

  types-aiobotocore-textract =
    buildTypesAiobotocorePackage "textract" "3.1.1"
      "sha256-8AE30iSji4gZH1ga2R9OOBW1ZhfYncsAYvJ30QHMKWw=";

  types-aiobotocore-timestream-query =
    buildTypesAiobotocorePackage "timestream-query" "3.1.1"
      "sha256-it4qUJvRK1UszVrcG8SV+tjmgt+951NwOymZLP7qiv0=";

  types-aiobotocore-timestream-write =
    buildTypesAiobotocorePackage "timestream-write" "3.1.1"
      "sha256-T4/9DYqKRp8OEHA4r9Wkb8iW6+yTho3D0d/6MGrebQA=";

  types-aiobotocore-tnb =
    buildTypesAiobotocorePackage "tnb" "3.1.1"
      "sha256-fdJJtgZBcz1R70iP/8rsw5f2denHcvQMtj2oABfN9b0=";

  types-aiobotocore-transcribe =
    buildTypesAiobotocorePackage "transcribe" "3.1.1"
      "sha256-eDv/gZST1YBOzY9jZ2tcVrvRG4iQjcCpHN01hEv79pM=";

  types-aiobotocore-transfer =
    buildTypesAiobotocorePackage "transfer" "3.1.1"
      "sha256-xNYIGy73VrL2KAHqyDZDXI0yxmbCmPZiDcWG91LwpSk=";

  types-aiobotocore-translate =
    buildTypesAiobotocorePackage "translate" "3.1.1"
      "sha256-F4FGlAV9zhW02axSImRi2Z5dY88GUXIvtXAeCAqkXA4=";

  types-aiobotocore-verifiedpermissions =
    buildTypesAiobotocorePackage "verifiedpermissions" "3.1.1"
      "sha256-agM4QnbjwiQv7L9E/FVaK9UN4KhL8bbyjfescFcTkXM=";

  types-aiobotocore-voice-id =
    buildTypesAiobotocorePackage "voice-id" "3.1.1"
      "sha256-jMKm4sZjAT1JiwOGfNjHwBLM7nbSnFUjzRwSiHKqpA4=";

  types-aiobotocore-vpc-lattice =
    buildTypesAiobotocorePackage "vpc-lattice" "3.1.1"
      "sha256-PkGkxoiiSe04jeQ4voPQvkMMFcvy8r4c9umMk70sjAk=";

  types-aiobotocore-waf =
    buildTypesAiobotocorePackage "waf" "3.1.1"
      "sha256-72fSxAns3WHmrdmZOJkV0SNcbw/2ftUxrP8yjPIJ79g=";

  types-aiobotocore-waf-regional =
    buildTypesAiobotocorePackage "waf-regional" "3.1.1"
      "sha256-/tcKP+RFvgy9IqCmDs8EOF3MBcuivLzxT2ahf5cuWG0=";

  types-aiobotocore-wafv2 =
    buildTypesAiobotocorePackage "wafv2" "3.1.1"
      "sha256-vM2qHczDDGFQykTxOMhXRgB1k+zDWbQHaejTtLhHnQ8=";

  types-aiobotocore-wellarchitected =
    buildTypesAiobotocorePackage "wellarchitected" "3.1.1"
      "sha256-dc7Emr6OZLt2cXgE5DHKV3S64bwdRK40nqjfxuAuFjY=";

  types-aiobotocore-wisdom =
    buildTypesAiobotocorePackage "wisdom" "3.1.1"
      "sha256-4BbO3YO4zVVxuF9yXln8CvyejIbV8Di5z6SCPqlNju8=";

  types-aiobotocore-workdocs =
    buildTypesAiobotocorePackage "workdocs" "3.1.1"
      "sha256-/n9kptl3kjFWaCnfhj7ZTs2FsoFbyqx3Lw+cCKGg2PM=";

  types-aiobotocore-worklink =
    buildTypesAiobotocorePackage "worklink" "2.15.1"
      "sha256-VvuxiybvGaehPqyVUYGO1bbVSQ0OYgk6LbzgoKLHF2c=";

  types-aiobotocore-workmail =
    buildTypesAiobotocorePackage "workmail" "3.1.1"
      "sha256-VUDDXQea77SesZFPUNaW7N4ks1Vhn2qr+iPYDhA89y4=";

  types-aiobotocore-workmailmessageflow =
    buildTypesAiobotocorePackage "workmailmessageflow" "3.1.1"
      "sha256-/w7qTqFuOPU6yOyr5JzY7RwBGyhbBfhwS6OGCFLBXog=";

  types-aiobotocore-workspaces =
    buildTypesAiobotocorePackage "workspaces" "3.1.1"
      "sha256-60MKEc3GWpYacygjiaHdG/Bpst3MKyuGZAUnHpDppfw=";

  types-aiobotocore-workspaces-web =
    buildTypesAiobotocorePackage "workspaces-web" "3.1.1"
      "sha256-wSAu3G8zsTFYlAxDKXW6eBm4L+khDspMw/zehf32a44=";

  types-aiobotocore-xray =
    buildTypesAiobotocorePackage "xray" "3.1.1"
      "sha256-FKDzj+WCtRIbawt6+zaKiGeXOg0vVQ3LQIgrsEz40Z0=";
}
