#!/bin/bash

# Get the last commit date in ISO 8601 format
last_commit_date=$(git log -1 --format=%cI 2>/dev/null)

# If there is no commit, pick a date 12 months ago
if [ -z "$last_commit_date" ]; then
    last_commit_date=$(date -v-24m "+%Y-%m-%d")
fi

# Print the starting date
echo "Starting from: $last_commit_date"

# Iterate over every day since the last commit date until today
current_date="$last_commit_date"
today=$(date "+%Y-%m-%d")

while [ "$current_date" \< "$today" ]; do
    # Generate a random number of commits (0 to 15)
    num_commits=$((RANDOM % 16))
    echo "Creating $num_commits commits for $current_date"

    for ((i=1; i<=num_commits; i++)); do
        echo "Commit #$i on $current_date" > pointless.txt
        git add pointless.txt
        commit_time=$(date -j -v+${i}H -f "%Y-%m-%d" "$current_date" "+%H:%M:%S")
        GIT_COMMITTER_DATE="$current_date $commit_time" git commit --date="$current_date $commit_time" -m "pointless commit #$i on $current_date"
    done

    # Move to the next day
    current_date=$(date -j -v+1d -f "%Y-%m-%d" "$current_date" "+%Y-%m-%d")

    # Stop if the next date would go past today
    if [ "$current_date" \> "$today" ]; then
        break
    fi

done