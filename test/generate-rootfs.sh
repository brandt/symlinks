#!/usr/bin/env bash
#
# Unit test for symlinks
# Generate artificial rootfs for testing purpose
#

SYMLINKS_BIN=../symlinks
ROOTFS_FOLDER=rootfs
TEST_FOLDER=$(dirname $0)

# create rootfs folder and cd into it
mkdir -p $TEST_FOLDER/$ROOTFS_FOLDER
cd $TEST_FOLDER/$ROOTFS_FOLDER

echo "* Creating artificial rootfs in $TEST_FOLDER/$ROOTFS_FOLDER"


###################################################################################################
# Create an example rootfs 
###################################################################################################
mkdir -p    usr                                   \
            lib                                   \
            etc                                   \
            opt                                   \
            usr/bin                               \
            usr/sbin                              \
            usr/share                             \
            usr/lib                               \
            usr/lib/toolchain/bin                 \
            usr/lib/libsomething                  \
            usr/lib/jvm/java-1.5-jdk-1.5.2/bin    \
            etc/alternatives                      \
            lib/toolchain1/bin                    \
            lib/toolchain2/bin    

touch       usr/lib/libsomething/libsomething.so.1.1.1   \
            usr/lib/libsomething/libsomething.so.1.1.2    \
            usr/lib/libsomething/libsomething.so.1.2.1    \
            usr/lib/libsomething/libsomething.so.1.2.2    \
            usr/lib/libsomething/libsomething.so.1.2.3    \
            usr/lib/libsomething/libsomething.so.2.1.1    \
            usr/lib/libsomething/libsomething.so.2.1.2    \
            usr/lib/libsomething/libsomething.so.2.1.3    \
            lib/toolchain1/bin/tool1                      \
            lib/toolchain1/bin/tool2                      \
            lib/toolchain2/bin/tool1                      \
            lib/toolchain2/bin/tool2                      \
            usr/lib/jvm/java-1.5-jdk-1.5.2/jdk-config     \
            usr/lib/jvm/java-1.5-jdk-1.5.2/bin/java

###################################################################################################
# Test case #1:     normal chained / cascaded symlinks in the case of software versioning
#
# Expected Result:  do nothing, everything is fine here!
###################################################################################################
ln -sf  libsomething.so.1.1.2 \
        usr/lib/libsomething/libsomething.so.1.1
ln -sf  libsomething.so.1.2.3 \
        usr/lib/libsomething/libsomething.so.1.2
ln -sf  libsomething.so.1.2.3 \
        usr/lib/libsomething/libsomething.so.1
ln -sf  libsomething.so.2.1.3 \
        usr/lib/libsomething/libsomething.so.2.1
ln -sf  libsomething.so.2.1 \
        usr/lib/libsomething/libsomething.so.2
ln -sf  libsomething.so.2 \
        usr/lib/libsomething/libsomething.so
ln -s   java-1.5-jdk-1.5.2 \
        usr/lib/jvm/java-1.5-jdk

###################################################################################################
# Test case #2:     absolute symlinks
#
# Expected result:  change absolute symlinks into relative ones
###################################################################################################
ln -sf  /lib/toolchain2/bin/tool1    \
        usr/lib/toolchain/bin/
ln -sf  /lib/toolchain2/bin/tool2    \
        usr/lib/toolchain/bin/


###################################################################################################
# Test case #3:     detect dangling symlinks as in the case of messed up library versioning
#
# Expected result:  detect and delete all symlinks which are involved
###################################################################################################
# now let's create a symlink to a target which doesn't exist
ln -sf  libsomething.so.2.1.4       \
        usr/lib/libsomething/libsomething.so.2.1


###################################################################################################
# Test case #4:     recursive mess of absolute symlinks
#
# Expected result:  resolve all symlinks, at least after second run!
###################################################################################################
ln -sf  /usr/lib/toolchain/bin/tool1            \
        etc/alternatives/
ln -sf  /usr/lib/toolchain/bin/tool2            \
        etc/alternatives/
ln -sf  /usr/lib/jvm/java-1.5-jdk               \
        etc/alternatives/java-sdk
ln -sf  /usr/lib/jvm/java-1.5-jdk/bin/java      \
        etc/alternatives/java
ln -sf  /etc/alternatives/java                  \
        usr/bin/

