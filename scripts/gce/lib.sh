# SPDX-License-Identifier: GPL-2.0

import_gce_terraform_vars()
{
	GCEPROJECT=$CONFIG_TERRAFORM_GCE_PROJECT_NAME
	GCEREGION=$CONFIG_TERRAFORM_GCE_REGION_LOCATION
	GCEMACHINETYPE=$CONFIG_TERRAFORM_GCE_MACHINE_TYPE
	GCESCRATCHDISKTYPE=$CONFIG_TERRAFORM_GCE_SCRATCH_DISK_INTERFACE
	GCEIMAGENAME=$CONFIG_TERRAFORM_GCE_IMAGE
	GCECREDENTIALS=$CONFIG_TERRAFORM_GCE_JSON_CREDENTIALS_PATH
}