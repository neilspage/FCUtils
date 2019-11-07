echo '[Stack Compare Utils]'

region='ap-southeast-2'

incorrect_usage() {
    echo 'Error, incorrect usage. Correct arguments: <old_stack> <new_stack> <aws_region>'
    echo '<aws_region> is optional, and will be ap-southeast-2 by default'
    exit 1
}

compare_stack_sizes() {
    oldAppStack=`echo "($2,$3,$4)"`
    newAppStack=`echo "($5,$6,$7)"`
    same='FALSE'
    if test $oldAppStack = $newAppStack
    then
        same='TRUE'
    fi
    echo "$1... ($2,$3,$4) vs ($5,$6,$7)...IS SAME:${same}"
}

if test $# -lt 2 
then
    incorrect_usage
fi

if test -z "$3"
then
    region='ap-southeast-2'
else
    region=$3
fi

echo Comparing stack $1 against $2.

old_stack=`aws autoscaling describe-auto-scaling-groups --region ${region} | jq -r '.AutoScalingGroups[] | "\(.AutoScalingGroupName) \(.DesiredCapacity) \(.MinSize) \(.MaxSize)"' | grep $1`

IFS='
' old_stack_array=($old_stack)

new_stack=`aws autoscaling describe-auto-scaling-groups --region ${region} | jq -r '.AutoScalingGroups[] | "\(.AutoScalingGroupName) \(.DesiredCapacity) \(.MinSize) \(.MaxSize)"' | grep $2`

IFS='
' new_stack_array=($new_stack)


echo 'StackNameApp... (desired,min,max) vs (desired,min,max)...<TRUE|FALSE if SAME>'
for key in ${!old_stack_array[@]}
do
  oldStackItem=`echo ${old_stack_array[$key]} | sed 's/ /-/g'` 
  newStackItem=`echo ${new_stack_array[$key]} | sed 's/ /-/g'`
  oldStackItemName=`echo $oldStackItem | cut -d"-" -f5`
  newStackItemName=`echo $newStackItem | cut -d"-" -f5`
  oldStackItemDesSize=`echo $oldStackItem | cut -d"-" -f9`
  oldStackItemMinSize=`echo $oldStackItem | cut -d"-" -f10`
  oldStackItemMaxSize=`echo $oldStackItem | cut -d"-" -f11`
  newStackItemDesSize=`echo $newStackItem | cut -d"-" -f9`
  newStackItemMinSize=`echo $newStackItem | cut -d"-" -f10`
  newStackItemMaxSize=`echo $newStackItem | cut -d"-" -f11`
  compare_stack_sizes $oldStackItemName $oldStackItemDesSize $oldStackItemMinSize $oldStackItemMaxSize $newStackItemDesSize $newStackItemMinSize $newStackItemMaxSize;
done
