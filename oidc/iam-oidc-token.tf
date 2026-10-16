# ================= GitHub OIDC provider (account mein EK hi baar) =================
#
# AWS ko batata hai: "GitHub ke tokens par bharosa karo". Iski koi cost nahi.
#
# Har service ka DEPLOY ROLE yahan nahi banta. Wo uconia-golden-path repo ke
# modules/ecs-service/iam.tf mein banta hai:
#   uconia-api-github-deploy → sirf abhishekpatwa-ai/uconia-api ki main branch le sakti hai,
#   aur sirf uconia-api ko deploy kar sakti hai.

resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com" # GitHub ka token issuer
  client_id_list = ["sts.amazonaws.com"]                         # token AWS STS ke liye bana ho (aud)
}
