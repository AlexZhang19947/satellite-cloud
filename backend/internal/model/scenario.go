package model

import (
    "time"

    "gorm.io/datatypes"
    "gorm.io/gorm"
)

// Scenario 场景模型
type Scenario struct {
	ID            uint           `gorm:"primaryKey" json:"id"`
	Name          string         `gorm:"type:varchar(255);not null" json:"name"`
	Epoch         string         `gorm:"type:varchar(100)" json:"epoch"`
	StartTime     string         `gorm:"type:varchar(100)" json:"start_time"`
	EndTime       string         `gorm:"type:varchar(100)" json:"end_time"`
	AltKm         float64        `json:"alt_km"`
	IncDeg        float64        `json:"inc_deg"`
	NPlanes       int            `json:"n_planes"`
	NSatsPerPlane int            `json:"n_sats_per_plane"`
	SensorConfig  datatypes.JSONMap `gorm:"type:jsonb" json:"sensor_config"`
	CreatedAt     time.Time      `json:"created_at"`
	UpdatedAt     time.Time      `json:"updated_at"`
	DeletedAt     gorm.DeletedAt `gorm:"index" json:"-"`

	// 关联
	Satellites []Satellite `gorm:"foreignKey:ScenarioID" json:"satellites,omitempty"`
}

// TableName 指定表名
func (Scenario) TableName() string {
	return "scenarios"
}

// ScenarioListResponse 场景列表响应（不包含卫星详情）
type ScenarioListResponse struct {
	ID            uint   `json:"id"`
	Name          string `json:"name"`
	Epoch         string `json:"epoch"`
	StartTime     string `json:"start_time"`
	EndTime       string `json:"end_time"`
	AltKm         float64 `json:"alt_km"`
	IncDeg        float64 `json:"inc_deg"`
	NPlanes       int    `json:"n_planes"`
	NSatsPerPlane int    `json:"n_sats_per_plane"`
	SatellitesCount int  `json:"satellites_count"`
}
