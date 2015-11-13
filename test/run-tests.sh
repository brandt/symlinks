#!/usr/bin/env bash
#
# Unit test for symlinks
# Run test on a test set e.g. an artificially created rootfs
#

SYMLINKS_BIN=../symlinks
ROOTFS_FOLDER=rootfs
ROOTFS_DANGLING_LINKS=3
TEST_FOLDER=$(dirname $0)

echo "* Running unit tests on $TEST_FOLDER/$ROOTFS_FOLDER"


###################################################################################################
# Simple test which should cover all test cases implemented in (generate-rootfs.sh):
#
# Test case #1:       normal chained / cascaded symlinks in the case of software versioning
# Expected Result:    do nothing, everything is fine here!
#
# Test case #2:       absolute symlinks
# Expected result:    change absolute symlinks into relative ones
#
# Test case #3:       detect dangling symlinks as in the case of messed up library versioning
# Expected result:    detect and delete all symlinks which are involved
#
# Test case #4:       recursive mess of absolute symlinks
# Expected result:    resolve all symlinks, at least after second run!
###################################################################################################

# let's run symlink against the just generated rootfs folder and see how it does:

# cd into rootfs folder first
cd $TEST_FOLDER/$ROOTFS_FOLDER

# call 'symlinks' to convert all absolute symlinks to relative ones with the following options:
#     -v    verbose
#     -r    recursive
#     -c    change absolute links into relative links
COUNT=0
while [ "$(../$SYMLINKS_BIN -verc . | grep absolute)" ]; do
    COUNT=$((COUNT+1))
    echo "Test run #$COUNT"
done

# call 'symlinks' again to get rid of the remaining dangling symlinks which could not be fixed
echo "Last run to fix the remaining dangling symlinks"
DANGLING_SYMLINKS_COUNT=$(../$SYMLINKS_BIN -verd . | grep dangling | wc -l)
echo "Removed $DANGLING_SYMLINKS_COUNT dangling links!"
if [ $DANGLING_SYMLINKS_COUNT -lt $ROOTFS_DANGLING_LINKS ]; then
    echo "Detected and removed too less broken symlinks!"
elif [ $DANGLING_SYMLINKS_COUNT -gt $ROOTFS_DANGLING_LINKS ]; then
    echo "Detected and removed too many broken symlinks!"
fi

# now let's look if there are broken symlinks left, 'find' offers some easy way to do that
BROKEN_SYMLINKS=$(find -L -type l)

# and also if there are still existing (maybe even working) absolute symlinks left
ABSOLUTE_SYMLINKS=$(find -type l -exec readlink {} \; | grep "^/")

if [ "$BROKEN_SYMLINKS" ] || [ "$ABSOLUTE_SYMLINKS" ]; then
    echo "Test failed, program was not able to fix all symlink problems..."
    if [ "$BROKEN_SYMLINKS" ]; then
        echo "The following symlinks have not been fixed:"
        for link in $BROKEN_SYMLINKS; do
            echo -e "\t * $link -> $(readlink $link)"
        done
    fi
    
    if [ "$ABSOLUTE_SYMLINKS" ]; then
        echo "There are still (maybe even working) absolute symlinks left:"
        for link in $ABSOLUTE_SYMLINKS; do
            echo -e "\t * $link -> $(readlink $link)"
        done
    fi
else
    echo "Test succeeded, it seems symlinks was able to solve all symlink problems!"
fi


