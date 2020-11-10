package main

import (
	"fmt"
	"log"

	"github.com/go-pg/pg/v10"
	"github.com/go-pg/pg/v10/orm"
)

type User struct {
	ID   string
	Name string
}

func (u *User) String() string {
	return fmt.Sprintf("User id:%d name:%s", u.ID, u.Name)
}

type Dao struct {
	db *pg.DB
}

func NewDao(host, user, password, dbname string) *Dao {
	d := new(Dao)

	info := fmt.Sprintf("host=%s user=%s password=%s dbname=%s sslmode=disable", host, user, password, dbname)
	log.Println(info)
	db := pg.Connect(&pg.Options{
		Addr:     host,
		User:     user,
		Password: password,
		Database: dbname,
	})

	d.db = db
	if err := d.createSchema(); err != nil {
		log.Println(err)
		d.Close()
		return nil
	}

	return d
}

func (d *Dao) createSchema() error {
	return d.db.Model((*User)(nil)).CreateTable(&orm.CreateTableOptions{
		IfNotExists: true,
	})
}

func (d *Dao) Close() {
	d.db.Close()
}

func (d *Dao) SetUser(id string, name string) error {
	_, err := d.db.Model(&User{
		ID:   id,
		Name: name,
	}).OnConflict("(id) DO Nothing").Insert()
	return err
}

func (d *Dao) GetUser(id string) (string, error) {
	u := &User{ID: id}
	err := d.db.Model(u).WherePK().Select()
	log.Println(u)
	if err != nil {
		return "", err
	}
	return u.Name, nil
}
