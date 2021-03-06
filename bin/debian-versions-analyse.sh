#!/bin/sh

#TOTAL
P_TOTAL=`aptitude search "!?automatic?installed"|wc -l`
echo "TOTAL PACKAGES MANUALLY INSTALLED:" $P_TOTAL"\n"

#stable
P_STABLE=`aptitude search '!?automatic?any-version(?installed ?archive(^stable$))'|wc -l`
echo "Stable:      " $P_STABLE
 
#backports
P_BACKPORTS=`aptitude search '!?automatic?any-version(?installed !?archive(^stable$) ?archive(backports))'|wc -l`
echo "Backported:  " $P_BACKPORTS

#testing
P_TESTING=`aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) ?archive(testing))'|wc -l`
echo "Testing:     " $P_TESTING

#unstable
P_UNSTABLE=`aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) ?archive(unstable))'|wc -l`
echo "Unstable:    " $P_UNSTABLE

#experimental
P_EXPERIMENTAL=`aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) ?archive(experimental))'|wc -l`
echo "Experimental:" $P_EXPERIMENTAL
 
#other
P_OTHER=`aptitude search '!?automatic?any-version(?installed !?archive(^stable$) !?archive(backports) !?archive(testing) !?archive(unstable) !?archive(experimental))'|wc -l`
echo "Other:       " $P_OTHER"\n"

#check if total = sum of parts
[ $(($P_STABLE+$P_BACKPORTS+$P_TESTING+$P_UNSTABLE+$P_EXPERIMENTAL+$P_OTHER)) -eq $P_TOTAL ] && echo "Checksum:     ok" || echo "Checksum:     error"
echo
