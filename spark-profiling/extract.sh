
#PAT="gsub(/138974/, \"\")gsub(/REMOTE_/, \"\")gsub(/TASK_START_TIME=/, \"[\")gsub(/TASK_FINISH_TIME=/, \"- \")gsub(/ TASK_RUN_TIME/, \"]\")gsub(/_TIME/, \"\")"

#echo $PAT

cat $1 | grep SHUFFLE_WRITE_TIME | cut -d ' ' -f 7,8,11,12,13,14,18,19,22 | awk '
gsub(/TASK_START_TIME=/, "[")\
gsub(/TASK_FINISH_TIME=/, "- ")\
gsub(/ TASK_RUN_TIME/, "]")\
gsub(/REMOTE_FETCH_WAIT_TIME/, "WAIT")\
gsub(/REMOTE_FETCH_TIME/, "FETCH")\
gsub(/138974/, "")\
gsub(/_TIME/, "")\
{print $0}'


