package model;

import java.util.Date;

public class Invoice2 {
    private int id;
    private String invoiceCode;
    private Date paymentTime;
    private float totalAmount; // tổng tiền hàng, do DAO tính bằng SQL, không lưu CSDL
    private float discountAmount;
    private float paidAmount; // tổng thanh toán = totalAmount - discountAmount, do DAO tính bằng SQL, không lưu CSDL
    private String paymentMethod;
    private Order2 order;
    private SalesStaff2 salesStaff;
    private MembershipCard2 membershipCard;

    public Invoice2() {
        super();
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getInvoiceCode() {
        return invoiceCode;
    }

    public void setInvoiceCode(String invoiceCode) {
        this.invoiceCode = invoiceCode;
    }

    public Date getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Date paymentTime) {
        this.paymentTime = paymentTime;
    }

    public float getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(float totalAmount) {
        this.totalAmount = totalAmount;
    }

    public float getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(float discountAmount) {
        this.discountAmount = discountAmount;
    }

    public float getPaidAmount() {
        return paidAmount;
    }

    public void setPaidAmount(float paidAmount) {
        this.paidAmount = paidAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Order2 getOrder() {
        return order;
    }

    public void setOrder(Order2 order) {
        this.order = order;
    }

    public SalesStaff2 getSalesStaff() {
        return salesStaff;
    }

    public void setSalesStaff(SalesStaff2 salesStaff) {
        this.salesStaff = salesStaff;
    }

    public MembershipCard2 getMembershipCard() {
        return membershipCard;
    }

    public void setMembershipCard(MembershipCard2 membershipCard) {
        this.membershipCard = membershipCard;
    }
}
