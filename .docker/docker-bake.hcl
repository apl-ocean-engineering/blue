#
#
#


variable "BLUE_ROS_DISTRO" { default = "rolling" }

variable "BLUE_GITHUB_REPO" { default = "robotic-decision-making-lab/blue" }

group "default" {
  targets = ["ci", "robot", "desktop", "desktop-nvidia"]
}

target "ci" {
  dockerfile = ".docker/Dockerfile"
  target = "ci"
  context = ".."
  args = {
    ROS_DISTRO = "${BLUE_ROS_DISTRO}"
  }
  tags = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-ci"
  ]
  cache_from =[
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-ci-cache",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-robot-cache",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-cache",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-nvidia-cache"
  ]
  cache_to = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-ci-cache"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "robot" {
  inherits = [ "ci" ]
  target = "robot"
  cache_to = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-robot-cache"
  ]
}

target "desktop" {
  inherits = [ "ci" ]
  target = "desktop"
  cache_to = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-cache"
  ]
}

target "desktop-nvidia" {
  inherits = [ "ci" ]
  target = "desktop-nvidia"
  cache_to = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-nvidia-cache"
  ]
}
