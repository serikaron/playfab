package main

const (
	host     = "postgres:5432"
	user     = "postgres"
	password = "wisdom"
	dbname   = "postgres"
)

func main() {
	dao := NewDao(host, user, password, dbname)
	defer dao.Close()
	c := Controller{dao: dao}
	c.Start()
}
