package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/appconfig"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

// TestComposableComplete verifies the deployed AppConfig configuration profile.
func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	verifyConfigurationProfile(t, ctx)
}

// TestComposableCompleteReadOnly verifies the deployed AppConfig configuration profile using read-only AWS API calls.
func TestComposableCompleteReadOnly(t *testing.T, ctx types.TestContext) {
	verifyConfigurationProfile(t, ctx)
}

func verifyConfigurationProfile(t *testing.T, ctx types.TestContext) {
	opts := ctx.TerratestTerraformOptions()
	region := terraform.Output(t, opts, "region")
	applicationID := terraform.Output(t, opts, "application_id")
	id := terraform.Output(t, opts, "id")
	name := terraform.Output(t, opts, "name")
	locationURI := terraform.Output(t, opts, "location_uri")
	profileType := terraform.Output(t, opts, "type")

	require.NotEqual(t, "", id)
	assert.Equal(t, terraform.Output(t, opts, "expected_name"), name)
	assert.Equal(t, terraform.Output(t, opts, "expected_location_uri"), locationURI)
	assert.Equal(t, terraform.Output(t, opts, "expected_type"), profileType)

	client := appConfigClient(t, region)
	profile, err := client.GetConfigurationProfile(context.Background(), &appconfig.GetConfigurationProfileInput{
		ApplicationId:          aws.String(applicationID),
		ConfigurationProfileId: aws.String(id),
	})
	require.NoError(t, err)

	assert.Equal(t, applicationID, aws.ToString(profile.ApplicationId))
	assert.Equal(t, id, aws.ToString(profile.Id))
	assert.Equal(t, name, aws.ToString(profile.Name))
	assert.Equal(t, locationURI, aws.ToString(profile.LocationUri))
	assert.Equal(t, profileType, aws.ToString(profile.Type))
}

func appConfigClient(t *testing.T, region string) *appconfig.Client {
	t.Helper()

	cfg, err := config.LoadDefaultConfig(context.Background(), config.WithRegion(region))
	require.NoError(t, err)

	return appconfig.NewFromConfig(cfg)
}
