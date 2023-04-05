class Response {
  Response({
    required this.inventory,
    required this.character,
    required this.progressions,
    required this.renderData,
    required this.activities,
    required this.equipment,
    required this.loadouts,
    required this.itemComponents,
    required this.uninstancedItemComponents,
  });

  Inventory inventory;
  Character character;
  Progressions progressions;
  RenderData renderData;
  Activities activities;
  ResponseEquipment equipment;
  Inventory loadouts;
  ItemComponents itemComponents;
  UninstancedItemComponents uninstancedItemComponents;
}

class Activities {
  Activities({
    required this.data,
    required this.privacy,
  });

  ActivitiesData data;
  int privacy;
}

class ActivitiesData {
  ActivitiesData({
    required this.dateActivityStarted,
    required this.availableActivities,
    required this.currentActivityHash,
    required this.currentActivityModeHash,
    required this.lastCompletedStoryHash,
  });

  DateTime dateActivityStarted;
  List<AvailableActivity> availableActivities;
  int currentActivityHash;
  int currentActivityModeHash;
  int lastCompletedStoryHash;
}

class AvailableActivity {
  AvailableActivity({
    required this.activityHash,
    required this.isNew,
    required this.canLead,
    required this.canJoin,
    required this.isCompleted,
    required this.isVisible,
    required this.displayLevel,
    required this.recommendedLight,
    required this.difficultyTier,
    required this.modifierHashes,
    required this.challenges,
    required this.booleanActivityOptions,
  });

  int activityHash;
  bool isNew;
  bool canLead;
  bool canJoin;
  bool isCompleted;
  bool isVisible;
  int displayLevel;
  int recommendedLight;
  int difficultyTier;
  List<int> modifierHashes;
  List<Challenge> challenges;
  Map<String, bool> booleanActivityOptions;
}

class Challenge {
  Challenge({
    required this.objective,
  });

  Objective objective;
}

class Objective {
  Objective({
    required this.objectiveHash,
    required this.activityHash,
    required this.progress,
    required this.completionValue,
    required this.complete,
    required this.visible,
    required this.destinationHash,
  });

  int objectiveHash;
  int activityHash;
  int progress;
  int completionValue;
  bool complete;
  bool visible;
  int destinationHash;
}

class Character {
  Character({
    required this.data,
    required this.privacy,
  });

  CharacterData data;
  int privacy;
}

class CharacterData {
  CharacterData({
    required this.membershipId,
    required this.membershipType,
    required this.characterId,
    required this.dateLastPlayed,
    required this.minutesPlayedThisSession,
    required this.minutesPlayedTotal,
    required this.light,
    required this.stats,
    required this.raceHash,
    required this.genderHash,
    required this.classHash,
    required this.raceType,
    required this.classType,
    required this.genderType,
    required this.emblemPath,
    required this.emblemBackgroundPath,
    required this.emblemHash,
    required this.emblemColor,
    required this.levelProgression,
    required this.baseCharacterLevel,
    required this.percentToNextLevel,
  });

  String membershipId;
  int membershipType;
  String characterId;
  DateTime dateLastPlayed;
  String minutesPlayedThisSession;
  String minutesPlayedTotal;
  int light;
  Map<String, int> stats;
  int raceHash;
  int genderHash;
  int classHash;
  int raceType;
  int classType;
  int genderType;
  String emblemPath;
  String emblemBackgroundPath;
  int emblemHash;
  EmblemColor emblemColor;
  Ion levelProgression;
  int baseCharacterLevel;
  int percentToNextLevel;
}

class EmblemColor {
  EmblemColor({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  int red;
  int green;
  int blue;
  int alpha;
}

class Ion {
  Ion({
    required this.progressionHash,
    required this.dailyProgress,
    required this.dailyLimit,
    required this.weeklyProgress,
    required this.weeklyLimit,
    required this.currentProgress,
    required this.level,
    required this.levelCap,
    required this.stepIndex,
    required this.progressToNextLevel,
    required this.nextLevelAt,
    required this.factionHash,
    required this.factionVendorIndex,
    required this.currentResetCount,
    required this.rewardItemStates,
  });

  int progressionHash;
  int dailyProgress;
  int dailyLimit;
  int weeklyProgress;
  int weeklyLimit;
  int currentProgress;
  int level;
  int levelCap;
  int stepIndex;
  int progressToNextLevel;
  int nextLevelAt;
  int factionHash;
  int factionVendorIndex;
  int currentResetCount;
  List<int> rewardItemStates;
}

class ResponseEquipment {
  ResponseEquipment({
    required this.data,
    required this.privacy,
  });

  EquipmentData data;
  int privacy;
}

class EquipmentData {
  EquipmentData({
    required this.items,
  });

  List<DataItem> items;
}

class DataItem {
  DataItem({
    required this.itemHash,
    required this.itemInstanceId,
    required this.quantity,
    required this.bindStatus,
    required this.location,
    required this.bucketHash,
    required this.transferStatus,
    required this.lockable,
    required this.state,
    required this.dismantlePermission,
    required this.isWrapper,
    required this.tooltipNotificationIndexes,
    required this.versionNumber,
    required this.overrideStyleItemHash,
  });

  int itemHash;
  String itemInstanceId;
  int quantity;
  int bindStatus;
  int location;
  int bucketHash;
  int transferStatus;
  bool lockable;
  int state;
  int dismantlePermission;
  bool isWrapper;
  List<int> tooltipNotificationIndexes;
  int versionNumber;
  int overrideStyleItemHash;
}

class Inventory {
  Inventory({
    required this.privacy,
  });

  int privacy;
}

class ItemComponents {
  ItemComponents({
    required this.instances,
    required this.objectives,
  });

  Instances instances;
  ItemComponentsObjectives objectives;
}

class Instances {
  Instances({
    required this.data,
    required this.privacy,
  });

  Map<String, InstancesDatum> data;
  int privacy;
}

class InstancesDatum {
  InstancesDatum({
    required this.damageType,
    required this.itemLevel,
    required this.quality,
    required this.isEquipped,
    required this.canEquip,
    required this.equipRequiredLevel,
    required this.unlockHashesRequiredToEquip,
    required this.cannotEquipReason,
    required this.energy,
    required this.primaryStat,
    required this.damageTypeHash,
  });

  int damageType;
  int itemLevel;
  int quality;
  bool isEquipped;
  bool canEquip;
  int equipRequiredLevel;
  List<int> unlockHashesRequiredToEquip;
  int cannotEquipReason;
  Energy energy;
  PrimaryStat primaryStat;
  int damageTypeHash;
}

class Energy {
  Energy({
    required this.energyTypeHash,
    required this.energyType,
    required this.energyCapacity,
    required this.energyUsed,
    required this.energyUnused,
  });

  int energyTypeHash;
  int energyType;
  int energyCapacity;
  int energyUsed;
  int energyUnused;
}

class PrimaryStat {
  PrimaryStat({
    required this.statHash,
    required this.value,
  });

  int statHash;
  int value;
}

class ItemComponentsObjectives {
  ItemComponentsObjectives({
    required this.data,
    required this.privacy,
  });

  MessageDataClass data;
  int privacy;
}

class Progressions {
  Progressions({
    required this.data,
    required this.privacy,
  });

  ProgressionsData data;
  int privacy;
}

class ProgressionsData {
  ProgressionsData({
    required this.progressions,
    required this.factions,
    required this.milestones,
    required this.quests,
    required this.uninstancedItemObjectives,
    required this.uninstancedItemPerks,
    required this.checklists,
    required this.seasonalArtifact,
  });

  Map<String, Ion> progressions;
  Map<String, Ion> factions;
  Map<String, Milestone> milestones;
  List<dynamic> quests;
  Map<String, List<Objective>> uninstancedItemObjectives;
  UninstancedItemPerks uninstancedItemPerks;
  Map<String, Map<String, bool>> checklists;
  SeasonalArtifact seasonalArtifact;
}

class Milestone {
  Milestone({
    required this.milestoneHash,
    required this.availableQuests,
    required this.order,
    required this.activities,
    required this.startDate,
    required this.endDate,
    required this.rewards,
  });

  int milestoneHash;
  List<AvailableQuest> availableQuests;
  int order;
  List<Activity> activities;
  DateTime startDate;
  DateTime endDate;
  List<Reward> rewards;
}

class Activity {
  Activity({
    required this.activityHash,
    required this.challenges,
    required this.modifierHashes,
    required this.booleanActivityOptions,
    required this.phases,
  });

  int activityHash;
  List<Challenge> challenges;
  List<int> modifierHashes;
  Map<String, bool> booleanActivityOptions;
  List<Phase> phases;
}

class Phase {
  Phase({
    required this.complete,
    required this.phaseHash,
  });

  bool complete;
  int phaseHash;
}

class AvailableQuest {
  AvailableQuest({
    required this.questItemHash,
    required this.status,
  });

  int questItemHash;
  Status status;
}

class Status {
  Status({
    required this.questHash,
    required this.stepHash,
    required this.stepObjectives,
    required this.tracked,
    required this.itemInstanceId,
    required this.completed,
    required this.redeemed,
    required this.started,
  });

  int questHash;
  int stepHash;
  List<Objective> stepObjectives;
  bool tracked;
  String itemInstanceId;
  bool completed;
  bool redeemed;
  bool started;
}

class Reward {
  Reward({
    required this.rewardCategoryHash,
    required this.entries,
  });

  int rewardCategoryHash;
  List<Entry> entries;
}

class Entry {
  Entry({
    required this.rewardEntryHash,
    required this.earned,
    required this.redeemed,
  });

  int rewardEntryHash;
  bool earned;
  bool redeemed;
}

class SeasonalArtifact {
  SeasonalArtifact({
    required this.artifactHash,
    required this.pointsUsed,
    required this.resetCount,
    required this.tiers,
  });

  int artifactHash;
  int pointsUsed;
  int resetCount;
  List<Tier> tiers;
}

class Tier {
  Tier({
    required this.tierHash,
    required this.isUnlocked,
    required this.pointsToUnlock,
    required this.items,
  });

  int tierHash;
  bool isUnlocked;
  int pointsToUnlock;
  List<TierItem> items;
}

class TierItem {
  TierItem({
    required this.itemHash,
    required this.isActive,
  });

  int itemHash;
  bool isActive;
}

class UninstancedItemPerks {
  UninstancedItemPerks({
    required this.the1600065451,
  });

  The1600065451 the1600065451;
}

class The1600065451 {
  The1600065451({
    required this.perks,
  });

  List<Perk> perks;
}

class Perk {
  Perk({
    required this.perkHash,
    required this.iconPath,
    required this.isActive,
    required this.visible,
  });

  int perkHash;
  String iconPath;
  bool isActive;
  bool visible;
}

class RenderData {
  RenderData({
    required this.data,
    required this.privacy,
  });

  RenderDataData data;
  int privacy;
}

class RenderDataData {
  RenderDataData({
    required this.customDyes,
    required this.customization,
    required this.peerView,
  });

  List<dynamic> customDyes;
  Customization customization;
  PeerView peerView;
}

class Customization {
  Customization({
    required this.personality,
    required this.face,
    required this.skinColor,
    required this.lipColor,
    required this.eyeColor,
    required this.hairColors,
    required this.featureColors,
    required this.decalColor,
    required this.wearHelmet,
    required this.hairIndex,
    required this.featureIndex,
    required this.decalIndex,
  });

  int personality;
  int face;
  int skinColor;
  int lipColor;
  int eyeColor;
  List<int> hairColors;
  List<int> featureColors;
  int decalColor;
  bool wearHelmet;
  int hairIndex;
  int featureIndex;
  int decalIndex;
}

class PeerView {
  PeerView({
    required this.equipment,
  });

  List<EquipmentElement> equipment;
}

class EquipmentElement {
  EquipmentElement({
    required this.itemHash,
    required this.dyes,
  });

  int itemHash;
  List<Dye> dyes;
}

class Dye {
  Dye({
    required this.channelHash,
    required this.dyeHash,
  });

  int channelHash;
  int dyeHash;
}

class UninstancedItemComponents {
  UninstancedItemComponents({
    required this.objectives,
  });

  UninstancedItemComponentsObjectives objectives;
}

class UninstancedItemComponentsObjectives {
  UninstancedItemComponentsObjectives({
    required this.data,
    required this.privacy,
  });

  Map<String, ObjectivesDatum> data;
  int privacy;
}

class ObjectivesDatum {
  ObjectivesDatum({
    required this.objectives,
  });

  List<Objective> objectives;
}

class Temperatures {
  Temperatures({
    required this.response,
    required this.errorCode,
    required this.throttleSeconds,
    required this.errorStatus,
    required this.message,
    required this.messageData,
  });

  Response response;
  int errorCode;
  int throttleSeconds;
  String errorStatus;
  String message;
  MessageDataClass messageData;
}

class MessageDataClass {
  MessageDataClass();
}

class Responses {
  Responses({
    required this.inventory,
    required this.character,
    required this.progressions,
    required this.renderData,
    required this.activities,
    required this.equipment,
    required this.loadouts,
    required this.itemComponents,
    required this.uninstancedItemComponents,
  });

  Inventory inventory;
  Character character;
  Progressions progressions;
  RenderData renderData;
  Activities activities;
  ResponseEquipment equipment;
  Inventory loadouts;
  ItemComponents itemComponents;
  UninstancedItemComponents uninstancedItemComponents;
}

class Activitiess {
  Activitiess({
    required this.data,
    required this.privacy,
  });

  ActivitiesData data;
  int privacy;
}

class ActivitiesDatas {
  ActivitiesDatas({
    required this.dateActivityStarted,
    required this.availableActivities,
    required this.currentActivityHash,
    required this.currentActivityModeHash,
    required this.lastCompletedStoryHash,
  });

  DateTime dateActivityStarted;
  List<AvailableActivity> availableActivities;
  int currentActivityHash;
  int currentActivityModeHash;
  int lastCompletedStoryHash;
}

class AvailableActivitys {
  AvailableActivitys({
    required this.activityHash,
    required this.isNew,
    required this.canLead,
    required this.canJoin,
    required this.isCompleted,
    required this.isVisible,
    required this.displayLevel,
    required this.recommendedLight,
    required this.difficultyTier,
    required this.modifierHashes,
    required this.challenges,
    required this.booleanActivityOptions,
  });

  int activityHash;
  bool isNew;
  bool canLead;
  bool canJoin;
  bool isCompleted;
  bool isVisible;
  int displayLevel;
  int recommendedLight;
  int difficultyTier;
  List<int> modifierHashes;
  List<Challenge> challenges;
  Map<String, bool> booleanActivityOptions;
}

class Challenges {
  Challenges({
    required this.objective,
  });

  Objective objective;
}

class Objectives {
  Objectives({
    required this.objectiveHash,
    required this.activityHash,
    required this.progress,
    required this.completionValue,
    required this.complete,
    required this.visible,
    required this.destinationHash,
  });

  int objectiveHash;
  int activityHash;
  int progress;
  int completionValue;
  bool complete;
  bool visible;
  int destinationHash;
}

class Characters {
  Characters({
    required this.data,
    required this.privacy,
  });

  CharacterData data;
  int privacy;
}

class CharacterDatas {
  CharacterDatas({
    required this.membershipId,
    required this.membershipType,
    required this.characterId,
    required this.dateLastPlayed,
    required this.minutesPlayedThisSession,
    required this.minutesPlayedTotal,
    required this.light,
    required this.stats,
    required this.raceHash,
    required this.genderHash,
    required this.classHash,
    required this.raceType,
    required this.classType,
    required this.genderType,
    required this.emblemPath,
    required this.emblemBackgroundPath,
    required this.emblemHash,
    required this.emblemColor,
    required this.levelProgression,
    required this.baseCharacterLevel,
    required this.percentToNextLevel,
  });

  String membershipId;
  int membershipType;
  String characterId;
  DateTime dateLastPlayed;
  String minutesPlayedThisSession;
  String minutesPlayedTotal;
  int light;
  Map<String, int> stats;
  int raceHash;
  int genderHash;
  int classHash;
  int raceType;
  int classType;
  int genderType;
  String emblemPath;
  String emblemBackgroundPath;
  int emblemHash;
  EmblemColor emblemColor;
  Ion levelProgression;
  int baseCharacterLevel;
  int percentToNextLevel;
}

class EmblemColors {
  EmblemColors({
    required this.red,
    required this.green,
    required this.blue,
    required this.alpha,
  });

  int red;
  int green;
  int blue;
  int alpha;
}

class Ions {
  Ions({
    required this.progressionHash,
    required this.dailyProgress,
    required this.dailyLimit,
    required this.weeklyProgress,
    required this.weeklyLimit,
    required this.currentProgress,
    required this.level,
    required this.levelCap,
    required this.stepIndex,
    required this.progressToNextLevel,
    required this.nextLevelAt,
    required this.factionHash,
    required this.factionVendorIndex,
    required this.currentResetCount,
    required this.rewardItemStates,
  });

  int progressionHash;
  int dailyProgress;
  int dailyLimit;
  int weeklyProgress;
  int weeklyLimit;
  int currentProgress;
  int level;
  int levelCap;
  int stepIndex;
  int progressToNextLevel;
  int nextLevelAt;
  int factionHash;
  int factionVendorIndex;
  int currentResetCount;
  List<int> rewardItemStates;
}

class ResponseEquipments {
  ResponseEquipments({
    required this.data,
    required this.privacy,
  });

  EquipmentData data;
  int privacy;
}

class EquipmentDatas {
  EquipmentDatas({
    required this.items,
  });

  List<DataItem> items;
}

class DataItems {
  DataItems({
    required this.itemHash,
    required this.itemInstanceId,
    required this.quantity,
    required this.bindStatus,
    required this.location,
    required this.bucketHash,
    required this.transferStatus,
    required this.lockable,
    required this.state,
    required this.dismantlePermission,
    required this.isWrapper,
    required this.tooltipNotificationIndexes,
    required this.versionNumber,
    required this.overrideStyleItemHash,
  });

  int itemHash;
  String itemInstanceId;
  int quantity;
  int bindStatus;
  int location;
  int bucketHash;
  int transferStatus;
  bool lockable;
  int state;
  int dismantlePermission;
  bool isWrapper;
  List<int> tooltipNotificationIndexes;
  int versionNumber;
  int overrideStyleItemHash;
}

class Inventorys {
  Inventorys({
    required this.privacy,
  });

  int privacy;
}

class ItemComponentss {
  ItemComponentss({
    required this.instances,
    required this.objectives,
  });

  Instances instances;
  ItemComponentsObjectives objectives;
}

class Instancess {
  Instancess({
    required this.data,
    required this.privacy,
  });

  Map<String, InstancesDatum> data;
  int privacy;
}

class InstancesDatums {
  InstancesDatums({
    required this.damageType,
    required this.itemLevel,
    required this.quality,
    required this.isEquipped,
    required this.canEquip,
    required this.equipRequiredLevel,
    required this.unlockHashesRequiredToEquip,
    required this.cannotEquipReason,
    required this.energy,
    required this.primaryStat,
    required this.damageTypeHash,
  });

  int damageType;
  int itemLevel;
  int quality;
  bool isEquipped;
  bool canEquip;
  int equipRequiredLevel;
  List<int> unlockHashesRequiredToEquip;
  int cannotEquipReason;
  Energy energy;
  PrimaryStat primaryStat;
  int damageTypeHash;
}

class Energys {
  Energys({
    required this.energyTypeHash,
    required this.energyType,
    required this.energyCapacity,
    required this.energyUsed,
    required this.energyUnused,
  });

  int energyTypeHash;
  int energyType;
  int energyCapacity;
  int energyUsed;
  int energyUnused;
}

class PrimaryStats {
  PrimaryStats({
    required this.statHash,
    required this.value,
  });

  int statHash;
  int value;
}

class ItemComponentsObjectivess {
  ItemComponentsObjectivess({
    required this.data,
    required this.privacy,
  });

  MessageDataClass data;
  int privacy;
}

class Progressionss {
  Progressionss({
    required this.data,
    required this.privacy,
  });

  ProgressionsData data;
  int privacy;
}

class ProgressionsDatas {
  ProgressionsDatas({
    required this.progressions,
    required this.factions,
    required this.milestones,
    required this.quests,
    required this.uninstancedItemObjectives,
    required this.uninstancedItemPerks,
    required this.checklists,
    required this.seasonalArtifact,
  });

  Map<String, Ion> progressions;
  Map<String, Ion> factions;
  Map<String, Milestone> milestones;
  List<dynamic> quests;
  Map<String, List<Objective>> uninstancedItemObjectives;
  UninstancedItemPerks uninstancedItemPerks;
  Map<String, Map<String, bool>> checklists;
  SeasonalArtifact seasonalArtifact;
}

class Milestones {
  Milestones({
    required this.milestoneHash,
    required this.availableQuests,
    required this.order,
    required this.activities,
    required this.startDate,
    required this.endDate,
    required this.rewards,
  });

  int milestoneHash;
  List<AvailableQuest> availableQuests;
  int order;
  List<Activity> activities;
  DateTime startDate;
  DateTime endDate;
  List<Reward> rewards;
}

class Activitys {
  Activitys({
    required this.activityHash,
    required this.challenges,
    required this.modifierHashes,
    required this.booleanActivityOptions,
    required this.phases,
  });

  int activityHash;
  List<Challenge> challenges;
  List<int> modifierHashes;
  Map<String, bool> booleanActivityOptions;
  List<Phase> phases;
}

class Phases {
  Phases({
    required this.complete,
    required this.phaseHash,
  });

  bool complete;
  int phaseHash;
}

class AvailableQuests {
  AvailableQuests({
    required this.questItemHash,
    required this.status,
  });

  int questItemHash;
  Status status;
}

class Statuss {
  Statuss({
    required this.questHash,
    required this.stepHash,
    required this.stepObjectives,
    required this.tracked,
    required this.itemInstanceId,
    required this.completed,
    required this.redeemed,
    required this.started,
  });

  int questHash;
  int stepHash;
  List<Objective> stepObjectives;
  bool tracked;
  String itemInstanceId;
  bool completed;
  bool redeemed;
  bool started;
}

class Rewards {
  Rewards({
    required this.rewardCategoryHash,
    required this.entries,
  });

  int rewardCategoryHash;
  List<Entry> entries;
}

class Entrys {
  Entrys({
    required this.rewardEntryHash,
    required this.earned,
    required this.redeemed,
  });

  int rewardEntryHash;
  bool earned;
  bool redeemed;
}

class SeasonalArtifacts {
  SeasonalArtifacts({
    required this.artifactHash,
    required this.pointsUsed,
    required this.resetCount,
    required this.tiers,
  });

  int artifactHash;
  int pointsUsed;
  int resetCount;
  List<Tier> tiers;
}

class Tiers {
  Tiers({
    required this.tierHash,
    required this.isUnlocked,
    required this.pointsToUnlock,
    required this.items,
  });

  int tierHash;
  bool isUnlocked;
  int pointsToUnlock;
  List<TierItem> items;
}

class TierItems {
  TierItems({
    required this.itemHash,
    required this.isActive,
  });

  int itemHash;
  bool isActive;
}

class UninstancedItemPerkss {
  UninstancedItemPerkss({
    required this.the1600065451,
  });

  The1600065451 the1600065451;
}

class The1600065451s {
  The1600065451s({
    required this.perks,
  });

  List<Perk> perks;
}

class Perks {
  Perks({
    required this.perkHash,
    required this.iconPath,
    required this.isActive,
    required this.visible,
  });

  int perkHash;
  String iconPath;
  bool isActive;
  bool visible;
}

class RenderDatas {
  RenderDatas({
    required this.data,
    required this.privacy,
  });

  RenderDataData data;
  int privacy;
}

class RenderDataDatas {
  RenderDataDatas({
    required this.customDyes,
    required this.customization,
    required this.peerView,
  });

  List<dynamic> customDyes;
  Customization customization;
  PeerView peerView;
}

class Customizations {
  Customizations({
    required this.personality,
    required this.face,
    required this.skinColor,
    required this.lipColor,
    required this.eyeColor,
    required this.hairColors,
    required this.featureColors,
    required this.decalColor,
    required this.wearHelmet,
    required this.hairIndex,
    required this.featureIndex,
    required this.decalIndex,
  });

  int personality;
  int face;
  int skinColor;
  int lipColor;
  int eyeColor;
  List<int> hairColors;
  List<int> featureColors;
  int decalColor;
  bool wearHelmet;
  int hairIndex;
  int featureIndex;
  int decalIndex;
}

class PeerViews {
  PeerViews({
    required this.equipment,
  });

  List<EquipmentElement> equipment;
}

class EquipmentElements {
  EquipmentElements({
    required this.itemHash,
    required this.dyes,
  });

  int itemHash;
  List<Dye> dyes;
}

class Dyes {
  Dyes({
    required this.channelHash,
    required this.dyeHash,
  });

  int channelHash;
  int dyeHash;
}

class UninstancedItemComponentss {
  UninstancedItemComponentss({
    required this.objectives,
  });

  UninstancedItemComponentsObjectives objectives;
}

class UninstancedItemComponentsObjectivess {
  UninstancedItemComponentsObjectivess({
    required this.data,
    required this.privacy,
  });

  Map<String, ObjectivesDatum> data;
  int privacy;
}

class ObjectivesDatums {
  ObjectivesDatums({
    required this.objectives,
  });

  List<Objective> objectives;
}
