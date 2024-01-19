[all]
%{ for node in nodes ~}
${ node["domain_name"] } ansible_host=${ node["network_address"] }
%{ endfor ~}
