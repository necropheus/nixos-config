{
  networking = {
    networkmanager.enable = true;
    hostName = "necropolis";
    firewall.allowedTCPPorts = [
      4173
      5173
    ];
  };
}
