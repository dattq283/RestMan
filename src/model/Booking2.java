package model;

import java.util.Date;

public class Booking2 {
    private int id;
    private Date bookingTime;
    private Date arrivalTime;
    private Date checkInTime;
    private int numberOfGuests;
    private String note;
    private Customer2 customer;
    private SalesStaff2 salesStaff;
    private Table2 table;

    public Booking2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Date getBookingTime() {
        return bookingTime;
    }

    public void setBookingTime(Date bookingTime) {
        this.bookingTime = bookingTime;
    }

    public Date getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(Date arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public Date getCheckInTime() {
        return checkInTime;
    }

    public void setCheckInTime(Date checkInTime) {
        this.checkInTime = checkInTime;
    }

    public int getNumberOfGuests() {
        return numberOfGuests;
    }

    public void setNumberOfGuests(int numberOfGuests) {
        this.numberOfGuests = numberOfGuests;
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
}
