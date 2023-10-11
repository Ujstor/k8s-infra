import jenkins.model.Jenkins
import hudson.model. *def call(String jobname, String versionType, String stage) {
  if ("$stage" == "get") {
    TAG = getTag(jobname, versionType, "get")
  }
  else {
    TAG = getTag(jobname, versionType, "change")
  }
  return TAG
}@NonCPS
def getTag(String jobname, String versionType, String stage) {
  def jenkins = Jenkins.getInstance()
  def job = Jenkins.instance.getItemByFullName(jobname)
  def TAG = "0.0.0"
  paramsDef = job.getProperty(ParametersDefinitionProperty.class)
  if (paramsDef) {
    paramsDef.parameterDefinitions.each {
      if ("PreviousVersion".equals(it.name)) {
        println "Current version is ${it.defaultValue}"
        if (stage == "get") {
          nextValue = getUpdatedVersion(versionType, it.defaultValue)
          println "Next version is ${nextValue}"
          TAG = "${nextValue}"
        }
        else {
          it.defaultValue = getUpdatedVersion(versionType, it.defaultValue)
          println "Version successfully set to ${it.defaultValue}"
          TAG = "${it.defaultValue}"
        }
      }
    } 
  }
  paramsDef = null
  jenkins = null
  job = null
  return TAG
}//determine the next version by the required type 
//and incrementing the current version
@NonCPS
def getUpdatedVersion(String versionType, String currentVersion) {
  def split = currentVersion.split('\\.')
  switch (versionType) {
  case "Patch":
    println "updating patch version"
    split[2] = 1 + Integer.parseInt(split[2])
    break
  case "Minor":
    println "updating minor version"
    split[2] = 0
    split[1] = 1 + Integer.parseInt(split[1])
    break;
  case "Major":
    println "updating major version"
    split[2] = 0
    split[1] = 0
    split[0] = 1 + Integer.parseInt(split[0])
    break;
  }return split.join('.')
}