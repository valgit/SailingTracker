# get and increment semantic version
version=$( git tag --list | sort -rV | head -1 );  # v0.1.1
version_point=${version##*.}  # 1
version_point=$((${version_point} + 1))  # 2
version="${version%.*}.${version_point}"  # v0.1.2
echo ${version}
