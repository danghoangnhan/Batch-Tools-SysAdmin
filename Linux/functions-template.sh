
# Index:
# 1. Information & Description:
# 2. Setup & Instructions:
# 3. Parameters:
# 4. Functions:
# 5. Main:
# 6. Footer:

# -------------------------------------------------------------------------------
# Information & Description:

# Clean-up log file for:
# /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.py
# e.g.
# /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.log

# /Information & Description
# -------------------------------------------------------------------------------
# Setup & Instructions:

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# To copy this script to Raspberry Pi via PuTTY:
#pscp "%UserProfile%\Documents\Flash Drive updates\Pi-Hole DNS server\DynDNS-NameSilo-RottenEggs-LogCleanup.sh" pi@my.pi:/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Make script executable:
# Note that to make a file executable, you must set the eXecutable bit, and for a shell script, the Readable bit must also be set:
#cd /home/pi/DynDNS/
#ls -l
#chmod a+rx DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#ls -l

# Permissions breakdown:
# drwxrwxrwx
# | |  |  |
# | |  |  others
# | |  group
# | user
# is directory?

# u  =  owner of the file (user)
# g  =  groups owner  (group)
# o  =  anyone else on the system (other)
# a  =  all

# + =  add permission
# - =  remove permission

# r  = read permission
# w  = write permission
# x  = execute permission

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# To run this script: 
#/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#cd /home/pi/DynDNS/
#./DynDNS-NameSilo-RottenEggs-LogCleanup.sh

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Schedule script to run automatically once every 2 weeks:
#crontab -l
#crontab -e
#0 0 */14 * * /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#crontab -l

# Schedule script to run automatically once every month:
#crontab -l
#crontab -e
#0 0 1 */1 * /home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LogCleanup.sh
#crontab -l

# m h  dom mon dow   command

# * * * * *  command to execute
# - - - - -
# ?? ?? ?? ?? ??
# ?? ?? ?? ?? ??
# ?? ?? ?? ?? +----- day of week (0 - 7) (0 to 6 are Sunday to Saturday, or use names; 7 is Sunday, the same as 0)
# ?? ?? ?? +---------- month (1 - 12)
# ?? ?? +--------------- day of month (1 - 31)
# ?? +-------------------- hour (0 - 23)
# +------------------------- min (0 - 59)

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# /Setup & Instructions
# -------------------------------------------------------------------------------
# Parameters:

CURRENT_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs.log"

#ARCHIVE_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LastTwoWeeks.log"
ARCHIVE_LOGFILE_PATH="/home/pi/DynDNS/DynDNS-NameSilo-RottenEggs-LastMonth.log"


# /Parameters
# -------------------------------------------------------------------------------
# Functions:

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

update_all_software()
{
  yum check-update
  sudo yum update
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/functions.html

add_a_user()
{
  USER=$1
  PASSWORD=$2
  shift; shift;
  # Having shifted twice, the rest is now comments ...
  COMMENTS=$@
  echo "Adding user $USER ..."
  echo useradd -c "$COMMENTS" $USER
  echo passwd $USER $PASSWORD
  echo "Added user $USER ($COMMENTS) with pass $PASSWORD"
}

adduser()
{
  USER=$1
  PASSWORD=$2
  shift; shift;
  # Having shifted twice, the rest is now comments ...
  COMMENTS=$@
  useradd -c "${COMMENTS}" $USER
  if [ "$?" -ne "0" ]; then
    echo "Useradd failed"
    return 1
  fi
  passwd $USER $PASSWORD
  if [ "$?" -ne "0" ]; then
    echo "Setting password failed"
    return 2
  fi
  echo "Added user $USER ($COMMENTS) with pass $PASSWORD"
}

#adduser bob letmein Bob Holness from Blockbusters
#ADDUSER_RETURN_CODE=$?
#if [ "$ADDUSER_RETURN_CODE" -eq "1" ]; then
#  echo "Something went wrong with useradd"
#elif [ "$ADDUSER_RETURN_CODE" -eq "2" ]; then 
#  echo "Something went wrong with passwd"
#else
#  echo "Bob Holness added to the system."
#fi

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/functions.html

factorial()
{
  if [ "$1" -gt "1" ]; then
    i=`expr $1 - 1`
    j=`factorial $i`
    k=`expr $1 \* $j`
    echo $k
  else
    echo 1
  fi
}

#while :
#do
#  echo "Enter a number:"
#  read x
#  factorial $x
#done    

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# /Functions
# -------------------------------------------------------------------------------
# Main:

# -------------------------------------------------------------------------------
# ===============================================================================
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Index of Main:
#===============================================================================
# 1: Get physical drives on system and partiotions
# 2: Get total size and % used for each physical drive
# 3: Edit partitions
# 4: Format disks
# 5: Mount/Un-mount drives to filesystem
#===============================================================================

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# https://www.shellscript.sh/

# Delete archive log file:
echo "Deleting archive log file (if exists):"
echo $ARCHIVE_LOGFILE_PATH
if [ -f $ARCHIVE_LOGFILE_PATH ]; then
	# File exists.
	echo "Deleting file..."
	rm $ARCHIVE_LOGFILE_PATH
else
	# File does not exist.
	echo "File does not exist."
fi

# Copy current log file to archive position:
echo $'\n'"Copying current log file to archive position:"
echo current: $CURRENT_LOGFILE_PATH
echo archive: $ARCHIVE_LOGFILE_PATH
cp $CURRENT_LOGFILE_PATH $ARCHIVE_LOGFILE_PATH

# Append footer message to archive log file:
echo $'\n'"Wrapping-up archive log file:"
#CURRENT_TIMESTAMP=`date --iso-8601=ns`
CURRENT_TIMESTAMP=`date --rfc-3339=seconds`
echo "Current date/time: $CURRENT_TIMESTAMP"
echo "-------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
echo $'\n' >> $ARCHIVE_LOGFILE_PATH
echo "-------------------------------------------------------------------------------" >> $ARCHIVE_LOGFILE_PATH
echo "Archived:" $CURRENT_TIMESTAMP $'\n' >> $ARCHIVE_LOGFILE_PATH
echo $'\n' >> $ARCHIVE_LOGFILE_PATH

# Delete current log file:
echo $'\n'"Deleting current log file:"
echo $CURRENT_LOGFILE_PATH
rm $CURRENT_LOGFILE_PATH

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# ===============================================================================
# -------------------------------------------------------------------------------

# /Main
# -------------------------------------------------------------------------------
# Footer:

echo "End of script."
echo $'\n'
exit 0

# /Footer
# -------------------------------------------------------------------------------



