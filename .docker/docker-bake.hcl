#
# By default this bakefile builds:
#  - the "ci" and "robot" stages for both arm64 and amd64, and
#  - the "desktop" and "desktop-nvidia" stages for amd64
# for ROS "rolling"
#
# To build all default targets and load to _this_ machine:
#
#    docker buildx bake --load
#
# To override this behavior, create a file "docker-bake.override.hcl" in
# this directory containing the following snippets (for example):
#
# To build both "ci" and "robot" for _only_ amd64:
#
#     target "ci" {
#      platforms = ["linux/amd64"]
#     }
#
# To set the ROS disto:
#
#     variable "BLUE_ROS_DISTRO" { default = "jazzy" }
#
# OR set the environment variable BLUE_ROS_DISTRO
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
  labels = {
    "org.opencontainers.image.source" = "https://github.com/${BLUE_GITHUB_REPO}"
  }
  cache_from =[
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-ci",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-robot",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop",
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-nvidia",
    "type=local,dest=.docker-cache"
  ]
  cache_to = [
    "type=local,dest=.docker-cache"
  ]
  platforms = ["linux/amd64", "linux/arm64"]
}

target "mavros" {
  inherits = [ "ci" ]
  target = "mavros"
  tags = [
  ]
  cache_to = [
    "type=local,dest=.docker-cache"
  ]
}

target "robot" {
  inherits = [ "ci" ]
  target = "robot"
  tags = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-robot"
  ]
  cache_to = [
    "type=local,dest=.docker-cache"
  ]
}

target "desktop" {
  inherits = [ "ci" ]
  target = "desktop"
  tags = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop"
  ]
  cache_to = [
    "type=local,dest=.docker-cache"
  ]
  platforms = ["linux/amd64"]
}

target "desktop-nvidia" {
  inherits = [ "desktop" ]
  target = "desktop-nvidia"
  tags = [
    "ghcr.io/${BLUE_GITHUB_REPO}:${BLUE_ROS_DISTRO}-desktop-nvidia"
  ]
  cache_to = [
    "type=local,dest=.docker-cache"
  ]
}
