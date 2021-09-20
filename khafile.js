// Auto-generated
let project = new Project('AgeOfXianxia_1_0_0');

project.addSources('Sources');
project.addLibrary("C:/Users/plore/Desktop/Util/ArmorySDK/armory");
project.addLibrary("C:/Users/plore/Desktop/Util/ArmorySDK/iron");
project.addLibrary("C:/Users/plore/Desktop/Util/ArmorySDK/lib/haxebullet");
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/lib/haxebullet/ammo/ammo.js", { notinlist: true });
project.addLibrary("C:/Users/plore/Desktop/Util/ArmorySDK/lib/haxerecast");
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/lib/haxerecast/js/recast/recast.js", { notinlist: true });
project.addParameter('-dce full');
project.addParameter('armory.trait.navigation.Navigation');
project.addParameter("--macro keep('armory.trait.navigation.Navigation')");
project.addParameter('arm.ui.MainMenuController');
project.addParameter("--macro keep('arm.ui.MainMenuController')");
project.addParameter('armory.trait.physics.bullet.RigidBody');
project.addParameter("--macro keep('armory.trait.physics.bullet.RigidBody')");
project.addParameter('arm.ui.MapEditorController');
project.addParameter("--macro keep('arm.ui.MapEditorController')");
project.addParameter('arm.world.Gamespace');
project.addParameter("--macro keep('arm.world.Gamespace')");
project.addParameter('armory.trait.internal.UniformsManager');
project.addParameter("--macro keep('armory.trait.internal.UniformsManager')");
project.addParameter('arm.ui.AnimEditorController');
project.addParameter("--macro keep('arm.ui.AnimEditorController')");
project.addParameter('armory.trait.physics.bullet.PhysicsWorld');
project.addParameter("--macro keep('armory.trait.physics.bullet.PhysicsWorld')");
project.addShaders("build_main/compiled/Shaders/*.glsl", { noembed: false});
project.addAssets("build_main/compiled/Assets/**", { notinlist: true });
project.addAssets("build_main/compiled/Shaders/*.arm", { notinlist: true });
project.addAssets("Bundled/config.arm", { notinlist: true });
project.addAssets("Bundled/sounds/bow_draw.wav", { notinlist: true });
project.addAssets("Bundled/sounds/bow_hit.wav", { notinlist: true });
project.addAssets("Bundled/sounds/bow_shoot.wav", { notinlist: true });
project.addAssets("Bundled/sounds/fire0.wav", { notinlist: true });
project.addAssets("Bundled/sounds/fire1.wav", { notinlist: true });
project.addAssets("Bundled/sounds/step0.wav", { notinlist: true });
project.addAssets("Bundled/sounds/step1.wav", { notinlist: true });
project.addAssets("Bundled/sounds/sword0.wav", { notinlist: true });
project.addAssets("Bundled/sounds/sword1.wav", { notinlist: true });
project.addAssets("Bundled/textures/blood_pool.png", { notinlist: true });
project.addAssets("Bundled/textures/blood_splatter.png", { notinlist: true });
project.addAssets("Bundled/textures/grid_bw.png", { notinlist: true });
project.addAssets("Bundled/textures/grid_g.png", { notinlist: true });
project.addAssets("Bundled/textures/grid_w.png", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/brdf.png", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_0.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_1.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_2.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_3.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_4.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_5.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_6.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/hosek/hosek_radiance_7.hdr", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/smaa_area.png", { notinlist: true });
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/smaa_search.png", { notinlist: true });
project.addLibrary("C:/Users/plore/Desktop/Util/ArmorySDK/lib/zui");
project.addAssets("C:/Users/plore/Desktop/Util/ArmorySDK/armory/Assets/font_default.ttf", { notinlist: false });
project.addDefine('arm_hosek');
project.addDefine('arm_csm');
project.addDefine('rp_hdr');
project.addDefine('rp_renderer=Forward');
project.addDefine('rp_shadowmap');
project.addDefine('rp_shadowmap_cascade=1024');
project.addDefine('rp_shadowmap_cube=512');
project.addDefine('rp_background=World');
project.addDefine('rp_render_to_texture');
project.addDefine('rp_compositornodes');
project.addDefine('rp_antialiasing=SMAA');
project.addDefine('rp_supersampling=1');
project.addDefine('rp_ssgi=SSAO');
project.addDefine('rp_dynres');
project.addDefine('arm_physics');
project.addDefine('arm_bullet');
project.addDefine('arm_navigation');
project.addDefine('arm_published');
project.addDefine('arm_soundcompress');
project.addDefine('arm_audio');
project.addDefine('arm_ui');
project.addDefine('arm_skin');
project.addDefine('arm_particles');
project.addDefine('arm_draworder_shader');
project.addDefine('arm_config');
project.addDefine('arm_loadscreen');
project.addDefine('arm_resizable');
project.addDefine('armory');


resolve(project);
