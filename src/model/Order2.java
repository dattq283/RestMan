package model;

import java.util.Date;

public class Order2 {
    private int id;
    private Date orderTime;
    private String orderType;
    private String note;
    private Customer2 customer;
    private SalesStaff2 salesStaff;
    private Table2 table;
    private Booking2 booking;
    private OrderedMenuItem2[] menuItems;
    private OrderedCombo2[] combos;

    public Order2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getOrderTime() {
        return orderTime;
    }

    public void setOrderTime(Date orderTime) {
        this.orderTime = orderTime;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Customer2 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer2 customer) {
        this.customer = customer;
    }

    public SalesStaff2 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff2 salesStaff) {
        this.salesStaff = salesStaff;
    }

    public Table2 getTable() {
        return table;
    }

    public void setTable(Table2 table) {
        this.table = table;
    }

    public Booking2 getBooking() {
        return booking;
    }

    public void setBooking(Booking2 booking) {
        this.booking = booking;
    }

    public OrderedMenuItem2[] getMenuItems() {
        return menuItems;
    }

    public void setMenuItems(OrderedMenuItem2[] menuItems) {
        this.menuItems = menuItems;
    }

    public OrderedCombo2[] getCombos() {
        return combos;
    }

    public void setCombos(OrderedCombo2[] combos) {
        this.combos = combos;
    }
}
