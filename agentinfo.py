#!/bin/bash

while true; do
    # Run the command to capture active agents' output
    active_output=$(/var/ossec/bin/agent_control -lc)

    # Extract the IDs of active agents and filter out lines that contain '(server)'
    unique_ids=$(echo "$active_output" | grep -v '(server)' | grep -oP 'ID: \K\d+' | sort -u)
    num_unique_ids=$(echo "$unique_ids" | wc -l)

    # Run the command to capture disconnected agents' output
    disconnected_output=$(/var/ossec/bin/agent_control -ln)

    # Extract the IDs of disconnected agents
    disconnected_ids=$(echo "$disconnected_output" | grep -oP 'ID: \K\d+' | sort -u)
    num_disconnected_ids=$(echo "$disconnected_ids" | wc -l)

    # Calculate total agents
    total_agents=$((num_unique_ids + num_disconnected_ids))

    # Format data for zabbix_sender
    hostname="Zabbix_server"
    active_key="active.agents"
    inactive_key="inactive.agents"
    total_key="total.agents"  # New variable for total agents
    server_ip="127.0.0.1"

    # Send active agents count
    zabbix_sender -z $server_ip -s $hostname -k $active_key -o $num_unique_ids

    # Send inactive agents count
    zabbix_sender -z $server_ip -s $hostname -k $inactive_key -o $num_disconnected_ids

    # Send total agents count
    zabbix_sender -z $server_ip -s $hostname -k $total_key -o $total_agents

    # Sleep for 1 minute before the next iteration
    sleep 60
done
