// Auto-generated
package ;
class Main {
    public static inline var projectName = 'AgeOfXianxia';
    public static inline var projectVersion = '1.0.0';
    public static inline var projectPackage = 'arm';
    public static function main() {
        iron.object.BoneAnimation.skinMaxBones = 65;
            iron.object.LightObject.cascadeCount = 4;
            iron.object.LightObject.cascadeSplitFactor = 0.800000011920929;
        armory.system.Starter.main(
            'MainMenu',
            0,
            true,
            true,
            true,
            1920,
            1080,
            1,
            true,
            armory.renderpath.RenderPathCreator.get
        );
    }
}
