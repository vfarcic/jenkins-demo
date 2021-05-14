set +e
kubectl create namespace $PROJECT-$BRANCH_NAME
set -e
cd kustomize/overlays/preview
kustomize edit set namespace $PROJECT-$BRANCH_NAME
kustomize edit set image $REGISTRY_USER/$PROJECT=$REGISTRY_USER/$PROJECT:$BRANCH_NAME-$BUILD_NUMBER
cat ingress.yaml
echo 111
cat ingress.yaml | sed -e "s@host: @host: xyz$BRANCH_NAME@g" >ingress.yaml
echo 222
cat ingress.yaml
echo 333
kustomize build . | kubectl apply --filename -
kubectl --namespace $PROJECT-$BRANCH_NAME rollout status deployment jenkins-demo