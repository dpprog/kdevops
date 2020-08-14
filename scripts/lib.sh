source ${TOPDIR}/scripts/lib_terraform.sh
source ${TOPDIR}/scripts/aws/lib.sh
source ${TOPDIR}/scripts/gce/lib.sh
source ${TOPDIR}/scripts/azure/lib.sh
source ${TOPDIR}/scripts/openstack/lib.sh

ANSIBLE_ENABLE=$CONFIG_KDEVOPS_ANSIBLE_PROVISION_ENABLE
PROVISIONPLAYBOOK=$CONFIG_KDEVOPS_ANSIBLE_PROVISION_PLAYBOOK
PLAYBOOKDIR=$CONFIG_KDEVOPS_PLAYBOOK_DIR
INVENTORY=$CONFIG_KDEVOPS_ANSIBLE_INVENTORY_FILE

if [[ "$CONFIG_KDEVOPS_WORKFLOW_FSTESTS" == "y" ]]; then
	FSTYP="$CONFIG_FSTESTS_FSTYP"
	TEST_DEV="$CONFIG_FSTESTS_TEST_DEV"
fi

SKIPANSIBLE="false"
ENABLEANSIBLE="true"
if [[ "$ANSIBLE_ENABLE" != "y" ]]; then
	SKIPANSIBLE="true"
	ENABLEANSIBLE="false"
fi

cat_template_hosts_sed()
{
	cat $1 | sed -e \
		'
		s|@KDEVOPSPYTHONINTERPRETER@|'"$KDEVOPSPYTHONINTERPRETER"'|g;
		s|@KDEVOPSPYTHONOLDINTERPRETER@|'"$KDEVOPSPYTHONOLDINTERPRETER"'|g;
		' | cat -s
}

cat_template_nodes_sed()
{
	cat $1 | sed -e \
		'
		s|@VAGRANTBOX@|'"$VAGRANTBOX"'|g;
		s|@VBOXVERSION@|'$VBOXVERSION'|g;
		s|@SKIPANSIBLE@|'$SKIPANSIBLE'|g;
		s|@PROVISIONPLAYBOOK@|'$PROVISIONPLAYBOOK'|g;
		s|@PLAYBOOKDIR@|'$PLAYBOOKDIR'|g;
		s|@INVENTORY@|'$INVENTORY'|g;
		' | cat -s
}

cat_template_terraform_sed()
{
	cat $1 | sed -e \
		'
		s|@LIMITBOXES@|'"$LIMITBOXES"'|g;
		s|@LIMITNUMBOXES@|'"$LIMITNUMBOXES"'|g;
		s|@AWSREGION@|'$AWSREGION'|g;
		s|@AWSAVREGION@|'$AWSAVREGION'|g;
		s|@AWSNAMESEARCH@|'$AWSNAMESEARCH'|g;
		s|@AWSVIRTTYPE@|'$AWSVIRTTYPE'|g;
		s|@AWSAMIOWNER@|'$AWSAMIOWNER'|g;
		s|@AWSINSTANCETYPE@|'$AWSINSTANCETYPE'|g;
		s|@AZURERESOURCELOCATION@|'$AZURERESOURCELOCATION'|g;
		s|@AZUREVMSIZE@|'$AZUREVMSIZE'|g;
		s|@AZUREMANAGEDDISKTYPE@|'$AZUREMANAGEDDISKTYPE'|g;
		s|@AZUREIMAGEPUBLISHER@|'$AZUREIMAGEPUBLISHER'|g;
		s|@AZUREIMAGEOFFER@|'$AZUREIMAGEOFFER'|g;
		s|@AZUREIMAGESKU@|'$AZUREIMAGESKU'|g;
		s|@AZUREIMAGEVERSION@|'$AZUREIMAGEVERSION'|g;
		s|@AZURECLIENTCERTPATH@|'$AZURECLIENTCERTPATH'|g;
		s|@AZURECLIENTCERTPASSWD@|'$AZURECLIENTCERTPASSWD'|g;
		s|@AZUREAPPLICATIONID@|'$AZUREAPPLICATIONID'|g;
		s|@AZURESUBSCRIPTIONID@|'$AZURESUBSCRIPTIONID'|g;
		s|@AZURETENANTID@|'$AZURETENANTID'|g;
		s|@GCEPROJECT@|'$GCEPROJECT'|g;
		s|@GCEREGION@|'$GCEREGION'|g;
		s|@GCEMACHINETYPE@|'$GCEMACHINETYPE'|g;
		s|@GCESCRATCHDISKTYPE@|'$GCESCRATCHDISKTYPE'|g;
		s|@GCEIMAGENAME@|'$GCEIMAGENAME'|g;
		s|@GCECREDENTIALS@|'$GCECREDENTIALS'|g;
		s|@OPENSTACKCLOUD@|'$OPENSTACKCLOUD'|g;
		s|@OPENSTACKPREFIX@|'$OPENSTACKPREFIX'|g;
		s|@OPENSTACKFLAVOR@|'$OPENSTACKFLAVOR'|g;
		s|@OPENSTACKIMAGE@|'"$OPENSTACKIMAGE"'|g;
		s|@OPENSTACKKEYNAME@|'$OPENSTACKKEYNAME'|g;
		s|@SSHCONFIGPUBKEYFILE@|'$SSHCONFIGPUBKEYFILE'|g;
		s|@SSHCONFIGUSER@|'$SSHCONFIGUSER'|g;
		s|@SSHCONFIGUPDATE@|'$SSHCONFIGUPDATE'|g;
		s|@SSHCONFIGFILE@|'$SSHCONFIGFILE'|g;
		s|@SSHCONFIGSTRICT@|'$SSHCONFIGSTRICT'|g;
		s|@SSHCONFIGBACKUP@|'$SSHCONFIGBACKUP'|g;
		s|@ENABLEANSIBLE@|'$ENABLEANSIBLE'|g;
		s|@PROVISIONPLAYBOOK@|'$PROVISIONPLAYBOOK'|g;
		s|@PLAYBOOKDIR@|'$PLAYBOOKDIR'|g;
		s|@INVENTORY@|'$INVENTORY'|g;
		' | cat -s
}

cat_fstests_config_sed()
{
	cat $1 | sed -e \
		'
		s|@FSTESTSTESTDEV@|'$FSTESTSTESTDEV'|g;
		s|@FSTESTSDIR@|'$FSTESTSDIR'|g;
		s|@FSTESTSSCRATCHDEVPOOL@|'"$FSTESTSSCRATCHDEVPOOL"'|g;
		s|@FSTESTSSCRATCHMNT@|'$FSTESTSSCRATCHMNT'|g;
		s|@FSTESTSLOGWRITESDEV@|'$FSTESTSLOGWRITESDEV'|g;
		s|@FSTESTSSCRATCHLOGDEV@|'$FSTESTSSCRATCHLOGDEV'|g;
		s|@FSTESTSSCRATCHRTDEV@|'$FSTESTSSCRATCHRTDEV'|g;
		' | cat -s
}
