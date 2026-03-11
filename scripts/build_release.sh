#!/bin/sh
set -eu

APP_NAME="upay_pro"
ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
DIST_DIR="${ROOT_DIR}/release"
BUILD_DIR="${DIST_DIR}/build"
VERSION="${1:-$(date +%Y%m%d%H%M%S)}"

build_one() {
  target_os="$1"
  target_arch="$2"
  package_name="${APP_NAME}-${target_os}-${target_arch}"
  output_dir="${BUILD_DIR}/${package_name}"
  archive_path="${DIST_DIR}/${package_name}-${VERSION}.zip"

  rm -rf "${output_dir}"
  mkdir -p "${output_dir}/${APP_NAME}"

  echo "Building ${package_name}..."
  CGO_ENABLED=0 GOOS="${target_os}" GOARCH="${target_arch}" \
    go build -o "${output_dir}/${APP_NAME}/${APP_NAME}" "${ROOT_DIR}"

  cp -R "${ROOT_DIR}/static" "${output_dir}/${APP_NAME}/static"

  (
    cd "${output_dir}"
    zip -qr "${archive_path}" "${APP_NAME}"
  )

  echo "Created ${archive_path}"
}

mkdir -p "${DIST_DIR}" "${BUILD_DIR}"

build_one linux amd64
build_one linux arm64

echo "Release packages are in ${DIST_DIR}"
