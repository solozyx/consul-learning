#!/usr/bin/env bash

# 部署1节点server集群
consul agent -server -bootstrap-expect 1 -data-dir /opt/soft/consul_data -node=n1 -bind=192.168.174.134 -ui -config-dir /opt/soft/consul_config -rejoin -join 192.168.174.134 -client 0.0.0.0 &

# 防火墙放开 8301 和 8500 端口
firewall-cmd --zone=public --add-port=8301/tcp --permanent
firewall-cmd --zone=public --add-port=8500/tcp --permanent
systemctl restart firewalld.service

# 部署1节点client
consul agent -data-dir /opt/soft/consul_data -node=n2 -bind=192.168.174.135 -config-dir /opt/soft/consul_config -rejoin -join 192.168.174.134 &

firewall-cmd --zone=public --add-port=8301/tcp --permanent
firewall-cmd --zone=public --add-port=8500/tcp --permanent
systemctl restart firewalld.service

# 查看集群状态
consul members
http://192.168.174.134:8500/ui/dc1/nodes
dig @127.0.0.1 -p 8600 web.service.consul
dig @127.0.0.1 -p 8600 web.service.consul SRV
